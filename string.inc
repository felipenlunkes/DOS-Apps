
%ifndef STRING_INC

%define STRING_INC

jmp STRING_INC_FIM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;          STR_LEN                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;bx=ponteiro para a string
;retorna o tamanhao no bx mesmo.

str_len:

push ax              ;NAO EMPILHA BX, POIS ELE GUARDARA O RESULTADO
push cx
xor cx,cx
xor ax,ax

;;************************************************************

_str_len_loop:

mov byte al,[bx]

cmp al,0
jz _str_len_fim

inc cx
inc bx
jmp _str_len_loop

;;************************************************************

_str_len_fim:

mov bx,cx             ;GUARDA O RESULTADO EM BX
pop cx
pop ax
  
ret



STRING_INC_FIM:
%endif