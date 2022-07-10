;;***********************************************************************
;;       ______
;;      /  __  \      Sistema Operacional PX-DOS®
;;     /  |__|  \     Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;;    /  _____   \    Todos os direitos reservados.  
;;   /   /    \   \     
;;  /___/      \___\  Aplicativos do sistema
;;
;;
;; Compatível com PX-DOS® 0.9.0 ou superior   
;;
;;***********************************************************************

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão de cabeçalho APPX

;;************************************************************

section .bss

  MAX_X equ 24
  MIN_X equ 2
  MAX_Y equ 80
  MIN_Y equ 2
  INCREMENTO equ 13
  INCREMENTO_SCORE equ 10

  DELAY equ 1
  def_cor equ 0fh
  VIDEO equ 0xb800
  ALTURA  equ 25        ;numero de linhas
  LARGURA equ 80        ;numero de colunas
  OCUPADO equ '1'       ;chars que indicam de uma posicao estah ocupada
  LIVRE   equ '0'       ;ou livre
  C equ 'C'
  B equ 'B'
  E equ 'E'
  D equ 'D'

;;************************************************************

_bss:

  matriz_tela resb ALTURA*LARGURA
  corpo resw ALTURA*LARGURA
  _x resb 1             ;guarda a posicao x da cabeca
  _y resb 1             ;guarda a posicao y da cabeca

  direcao resb 1
  tamanho_corpo resb 2
  fgbg resb 1
  KEY_E resb 'a'
  Numero resb 20h        ;buffer para guardar a string de um numero qualquer
  
_bss_end:

;;************************************************************

section .data

  SCORESTR db "Pontos: ",0
  debug_snake_ db "TPOS:",0
  BLANK db "´       Ã",0
  CHARS DB "@0*"
  food_xy db 0,0                ; Posição da Comida
  Score dw 0
  
SNAKE_LOGO:

DB     "       SNAKE para PX-DOS       ",0       
DB     "                    _          ",0
DB     "                   | |         ",0
DB     " ___  _ __    __ _ | | _   ___ ",0
DB     "/ __|| '_ \  / _` || |/ / / _ \",0
DB     "\__ \| | | || (_| ||   < |  __/",0
DB     "|___/|_| |_| \__,_||_|\_\ \___|",0;,'$'
DB     "  PRESSIONE ENTER PARA COMECAR ",0
DB     "                               ",0
DB     "                               ",0
DB     " Use a,s,d,w no teclado, para  ",0
DB     " movimentar a cobra pela tela. ",0
DB     "                               ",0,'$'

GAME_OVER:                                                           
DB "  __ _   __ _  _ __ ___    ___     ___  __   __  ___  _ ___",0
DB " / _` | / _` || '_ ` _ \  / _ \   / _ \ \ \ / / / _ \| '__/",0
DB "| (_| || (_| || | | | | ||  __/  | (_) | \ V / |  __/| |   ",0
DB " \__, | \__,_||_| |_| |_| \___|   \___/   \_/   \___||_|   ",0
DB "  __/ |                                                    ",0
DB " |___/                                                     ",0
db "                                                           ",0
db "                                                           ",0
db "                                                           ",0
db "Pressione ENTER para sair...",0
db "                                                           ",0
db "                                                           ",0,'$'
                                                               
;;************************************************************

section .text

  %include "string.inc"
  %include "stdio.inc"
  
  call clear

  mov ax,0718h
  mov bx,SNAKE_LOGO
  mov cl,0fh        ;atributo
  
  call draw_big_echo
  
  mov ah,0
  int 16h
  
  call clear
  call prepara_jogo
  
  mov ax,0028h
  
  mov cx,0fh
  mov word[tamanho_corpo],0014h
  mov byte[_x],0ah
  mov byte[_y],20h
  mov byte bl,[CHARS+1]
  mov byte[direcao],D       ;ter pra onde ir eh sempre bom :-)
  mov byte bh,def_cor
  mov ax,0101h
  
  call box
  
_draw:

  mov cx,DELAY              ;tempo de delay ~ 1/18 de segundo
  call delay
  call comida
  call recebe_entrada       ;verifica o teclado...e grava a direcao.
  call ajusta_direcao       ;muda a direcao de movimentacao, de acordo com a tecla lida do teclado
  call atualiza_cobra       ;desenha a cobra em sua nova posicao.
  call atualiza_matriz_tela ; de acordo com a matriz da cobra, muda a matriz da tela
  call refresh              ;redesenha a cobra na tela, e verifica se perdeu o jogo!
  call debug_snake

  mov byte ah,[_x]      
  mov byte al,[_y]      
  call get_char_matriz
  mov bl,al
  mov ax,184Fh          ; linha=18h, coluna=4fh
  mov bh,0fh            ; cor
  call draw_char        ;escreve um char na tela. ah=linha, al=coluna
  
  jmp _draw             ;força um loop infinito!

_sair:

  mov ah, 02h
  int 90h



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             DELAY                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
delay:
;  pushad
;  mov ah,86h
;  mov cx,03h
;  mov dx,0ffh
;  int 15h
;  popad
;  ret

   push ax
   push bx
   push ds

   mov ax,0040h
   mov ds,ax
   mov bx,6ch
   mov ax,[bx]
   add ax,cx
delay_loop:
   cmp ax,[bx]
   jnc delay_loop

   pop ds
   pop bx
   pop ax
   ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            ENTRADA                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
recebe_entrada:
  pushad
  mov ah,1        ;verifica se tem alguma tecla a ser lida do buffer
  int 16h
  jz buffer_limpo ;se nao tiver, termina
  mov ah,0        ;se tiver, leia!
  int 16h
  cmp al,1bh      ;compara com ESC
  jnz _cont       ;se nao for ESC, continua a rotina
  call clear
  mov ah,02h      ;se for ESC, termina o jogo!
  int 90h
  

_cont:
  cmp al,'a';[KEY_E]
  jz  _E          ;esquerda
  cmp al,'d'
  jz  _D          ;direita
  cmp al,'w'
  jz  _C          ;cima
  cmp al,'s'
  jz  _B          ;baixo
;  jmp buffer_limpo
  jmp fim         ; se nao for lida nenhuma tecla "valida",termina a rotina.
_E:
  mov bl,'E'
  mov byte al,[direcao]
  cmp al,D      ;se eu estiver indo pra direita e recebo ordem de ir na direcao
  jz  fim       ;contraria, nao faz nada!
  mov byte[direcao],E  
  jmp fim

_D:
  mov bl,'D'
  mov byte al,[direcao]
  cmp al,E
  jz  fim 
  mov byte[direcao],D
  jmp fim

_C:
  mov bl,'C'
  mov byte al,[direcao]
  cmp al,B
  jz  fim 
  mov byte[direcao],C
  jmp fim

_B:
  mov bl,'B'
  mov byte al,[direcao]
  cmp al,C
  jz  fim 
  mov byte[direcao],B
  jmp fim
buffer_limpo:
  mov bl,[direcao]
fim:
;  mov ax,1820h
;  call draw_char

  popad
  ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           AJUSTA DIRECAO               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ajusta_direcao:

 pushad
 mov byte bh,[_x]
 mov byte bl,[_y]

 mov byte al,[direcao]

 cmp al,E
 jnz _muda_direcao_D      ;se NAO estiver indo para esquerda,verifica se estah indo pra direita
 dec bl                   ;se ESTIVER indo paraesquerda, decrementa a posicao da coluna ( da cabeca da cobra )
 jmp _muda_direcao_fim

_muda_direcao_D:
 cmp al,D
 jnz _muda_direcao_C
 inc bl
 jmp _muda_direcao_fim

_muda_direcao_C:
 cmp al,C
 jnz _muda_direcao_B
 dec bh
 jmp _muda_direcao_fim

_muda_direcao_B:
 cmp al,B
 jnz _muda_direcao_fim
 inc bh

_muda_direcao_fim:
 mov byte[_x],bh        ;atualiza a nova posica da cabeca da cobra
 mov byte[_y],bl        ; _x = linha , _y = coluna
 popad
 ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           ATUALIZA_COBRA        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atualiza_cobra:
  pushad
  push bp
  xor bp,bp
  mov cx,[tamanho_corpo]   ;dispensa comentario!
  dec cx                   ;a matriz comeca do 0
  mov ax,2                 ;
  mul cx                   ;multiplica cx por ax, nesse caso por 2, pois CADA posicao da matriz 'corpo' tem 2 bytes
  mov bx,corpo             ;corpo = ponteiro para o inicio do corpo da cobra.
  add bx,ax                ;aponta para a ultima posicao do corpo da cobra
  push bx                  ;salva o ponteiro para a cauda da cobra
  mov ax,[bx]              ;
  mov bh,def_cor
  mov bl,' '               ;apaga a cauda da cobra.
  call draw_char           ;

;ax, guarda a linha,coluna do lugar onde estah a cauda da cobra.
;ah=linha, al=coluna

  mov bl,LIVRE              ;"libera" a posicao na matriz auxiliar.
  call put_char_matriz

  pop bx                   ;bx ainda aponta para a cauda da cobra

_a_loop:
;aplicar algoritmo: pos_atual = posicao_atual - 1; para cada byte das posicoes.
; e a cabeca recebe as informacoes de _x e _y
  sub bx,2
  mov ax,[bx]
  add bx,2
  mov [bx],ax
  sub bx,2
  loop _a_loop
  mov byte ah,[_x]         ;
  mov byte al,[_y]         ;desenha a cabeca na nova posicao
  mov [bx],ax              ;
  mov bl,[CHARS+1]         ;
  call draw_char           ; 

  pop bp
  popad
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     PREPARA JOGO           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

prepara_jogo:
  pushad
  push bp

  mov cx,_bss_end - _bss
  xor bp,bp
_1:
  mov byte[_bss+bp],LIVRE
  inc bp
  loop _1

  pop bp
  popad
  call clear
  ret





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      PUT CHAR MATRIZ TELA      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;coloca um char qer na posica indicada por ah,al (lin,col) na matriz
;da tela
;bl guarda o caractere
; como a matriz comeca SEMPRE de 0, existe a necessidade de decrementar o valor
; da linha E da coluna, onde serah escrito o dado, mas tem q tomar cuidado, pois
; de os valores JA vierem para a rotina com valor ZERO, NAO PODE DECREMENTAR!


put_char_matriz:
  pushad
  push ds
  push bp

;verifica se precisa decrementar os valores da linha e da coluna.

  cmp ah,0
  jz put_char_matriz_nao_decrementa_linha
  dec ah
put_char_matriz_nao_decrementa_linha:
  cmp al,0
  jz put_char_matriz_nao_decrementa_coluna
  dec al
put_char_matriz_nao_decrementa_coluna:


  xor dx,dx
  push bx           ;salva o caractere que vai ser escrito
                    ;posicao = ah*LARGURA + al
  mov bx,ax         ;guarda a posicao
  mov ax,LARGURA    ;para multiplicar por 80
  mov dl,bh         ;prepara a linha pra ser multiplicada
  mul dx            ;multiplica dx * ax , resultado em ax
  xor bh,bh         ;nao preciso mais do valor da linha
  add ax,bx         ; LINHA + COLUNA

  pop bx            ;recupera o caractere
  mov bp,ax                  
  mov byte[matriz_tela+bp],bl
  pop bp
  pop ds
  popad 
  ret   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   ATUALIZA MATRIZ TELA       ;
;le cada posicao do corpo da cobra e coloca na matriz da tela
atualiza_matriz_tela:

 pushad
 push bp

 xor bp,bp
 mov cx,[tamanho_corpo]   ;pega o tamanho do corpo da cobra
 add bp,2
 dec cx
_loop_:
 mov ax,[corpo+bp]     ;para cada posicao do corpo da cobra
 mov bl,'1'            ;adiciona essa posicao da matriz da tela
 call put_char_matriz  ;
 add bp,2
 loop _loop_           ;

 pop bp
 popad
 ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            REFRESH            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
refresh:
 pushad
 push bp

 xor bp,bp
 mov cx,[tamanho_corpo]
 mov byte bl,[CHARS]
 mov ax,[corpo+bp]
 call draw_char             ;desenha a cabeca
 add bp,2
 dec cx
refresh_draw_loop:
 mov ax,[corpo+bp]
 mov bl,[CHARS+1]
 call draw_char

 mov bl,OCUPADO
 call put_char_matriz
 add bp,2
 loop refresh_draw_loop

 mov byte ah,[_x]
 mov byte al,[_y]
 cmp ah,MIN_X
 jb acabou
 cmp ah,MAX_X
 jg acabou
 cmp al,MIN_Y
 jb acabou
 cmp al,MAX_Y
 jg acabou
 jmp nao_acabou

acabou:
  call _game_over

nao_acabou:
 ;verifica se comeu o a comida
 mov ah,[_x]
 mov al,[_y]
 mov bx,[food_xy]
 cmp ax,bx
 jnz nao_cresce        ;se nao tiver comido, nao cresce!
 mov cx,[tamanho_corpo]
 add cx,INCREMENTO
 mov [tamanho_corpo],cx
 mov cx,0h
 mov [food_xy],cx
 ;atualiza a pontuacao
 mov bx,SCORESTR
 mov ax,0140h
 mov cl,4fh
 call draw_string
 mov bx,SCORESTR
 call str_len
 mov ax,0140h
 add al,bl
 push ax
 xor ax,ax
 mov ax,[Score]
 add ax,INCREMENTO_SCORE       ;aumento da pontuacao a cada bonus!
 mov [Score],ax
 call binasc
 pop ax
 mov cl,4fh
 mov bx,Numero
 call draw_string

 jmp _refresh_fim
nao_cresce: 
 
;se nao tiver comido, pode ter perdido!
 mov ah,[_x]
 mov al,[_y]
 call get_char_matriz
 cmp al,LIVRE
 jnz _game_over

  mov ax,[food_xy]
  mov bl,[CHARS+2]
  mov bh,0fh
  call draw_char


_refresh_fim:
 pop bp
 popad
 ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        GET CHAT MATRIZ        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;retorna em ax o caractere q estiver em linha,coluna (ah,al)
get_char_matriz:
 push bx
 push dx
 push bp

;verifica se precisa decrementar os valores da linha e da coluna.

  cmp ah,0
  jz get_char_matriz_nao_decrementa_linha
  dec ah
get_char_matriz_nao_decrementa_linha:
  cmp al,0
  jz get_char_matriz_nao_decrementa_coluna
  dec al
get_char_matriz_nao_decrementa_coluna:


 mov bx,ax
 xor ax,ax
 mov ax,LARGURA
 xor dx,dx
 mov dl,bh
 mul dx
 xor bh,bh
 add ax,bx

 mov bp,ax
 mov byte al,[matriz_tela+bp]
   

 pop bp
 pop dx
 pop bx
 ret


_game_over:

  call clear
  mov ax,0703h
  mov bx,GAME_OVER
  mov cl,0fh
  call draw_big_echo

mov ax, 0
int 16h

call clear

 mov ah, 02h
 int 90h

                               
                               


  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        DEBUG SNAKE             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;escreve na tela a posicao da cabeca da cobra
debug_snake:



  pushad

  mov ax,1920h
  sub al,6h
  dec al
  mov bx,debug_snake_
  mov cl,0fh
  call draw_string


  mov ax,191fh
  mov bx,BLANK
  mov cl,0fh
  call draw_string

  mov al,[_x]
  mov ah,00h
  call binasc

  mov ax,1920h
  mov bl,'('
  mov bh,0fh
  call draw_char
  inc al

  mov bx,Numero
  
  call draw_string
  mov bx,Numero
  call str_len
  add al,bl
  mov bl,','
  mov ch,0fh
  call draw_char
  inc al
  push ax       ;guarda a posicao onde serah escrito o outro numero
  mov ah,00h
  mov al,[_y]
  call binasc
  pop ax
  mov bx,Numero
  call draw_string
  call str_len
  add al,bl
  mov bl,')'
  mov bh,0fh
  call draw_char

  popad
  ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        COMIDA           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sorteia uma posicao (x,y) para posicionar a comida
comida:
  push ax
  push bx
  push cx
 

  mov ax,[food_xy]
  cmp ax,00h      ;se a posicao da comida for diferente de 0,0 eh porque ainda existe comida na tela, entao nao precisa sortear denovo!
  jnz comida_fim

  push ds


  mov ax,0040h
  mov ds,ax
  mov di,6ch
  mov ax,[ds:di]
  mov dx, ax
  add dx, ax
  add dx, ax
  mul dx
 

  mov ah,00h
  mov bx,23
  div bl
  add ah,2    ;pois o limite inferior do jogo eh a linha 2, e o resto vai de 0 a 22
  mov ch,ah


;aqui comeca a rotina pra calcular coluna

  mov ax,[ds:di]
  mov dx, ax
  mul dx
  mul dx
;  add dx, ax


  mov ah,00h
  mov bx,78
  div bl
  add ah,2     ;as colunas vao de 1 a 80
  mov cl,ah

  pop ds
  mov [food_xy],cx

  mov ax,cx
  mov bl,[CHARS+2]
  mov bh,0fh
  call draw_char

  call put_char_matriz


comida_fim:

  pop cx
  pop bx
  pop ax
  ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;          BOX               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;desenha uma caixa .
; ah=linha inicial al=coluna inicial bh=linha final bl=colula final
box:
;BORDAS db "Ú Ä ¿À Ù ÚÛÜÝÞßàÈ É Ê Ë Ì Í Î Ï Ð Ñ ÒÓÔÕÖ×~"
ESPACO db "                                                                             ",0

  push bx
  push cx

  mov ax,0100h
  mov cx,80
box_loop1:
  mov ah,01h
  mov bl,' '
  mov bh,4fh
  call draw_char
  mov ah,19h
  call draw_char
  inc al
  loop  box_loop1

  mov ax,0100h
  mov cx,25
box_loop2:
  mov al,80
  mov bl,' '
  mov bh,4fh
  call draw_char
  mov al,00h
  call draw_char
  inc ah
  loop  box_loop2



  pop cx
  pop bx
  ret

