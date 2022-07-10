[BITS 16]

%include "C:\Dev\ASM\APPX\APPX.s"

jmp inicio


;;************************************************************

inicio:

mov ax, 19
int 10h ;; 320x200 com 256 cores
mov ax, 0a000h
mov es, ax ;; Definir DI para o segmento de memória de vídeo
xor bl, bl ;; BL será usado para armazenar o número da figura

;;************************************************************

novo:

inc bl

hlt ;; Processador irá aguardar

xor cx, cx
xor dx, dx ;; CX e DX representam as coordenadas
xor di, di ;; Defina di para o início da tela

;;************************************************************

a:

mov al, cl
xor al, dl
add al, dl
add al, bl ;; Cria uma cor
stosb      ;; Escreve um pixel
inc cx

cmp cx, 320 ;; Atualizar coordenadas
jne a

xor cx, cx
inc dx

cmp dx, 200
jne a

mov ah, 1  ;; Checa se alguma tecla foi pressionada
int 16h

jz novo ;; Se nenhuma tecla pressionada, exiba outra figura

mov ax, 3 ;; Retornar ao modo texto
int 10h

mov ah, 02h
mov bx, 1
int 90h