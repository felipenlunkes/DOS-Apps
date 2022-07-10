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
[BITS 16]

%include "C:\Dev\ASM\APPX\APPX.s" ;; Inclusão de cabeçalho APPX

mov ax, cs
mov bx, ax
mov es, ax

jmp Verificar

%include "C:\Dev\Asm\video.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************



Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

mov si, horas_msg
call escrever

mov bx, tmp_string
call obter_horario
mov si, bx
call escrever

mov si, data_msg
call escrever


mov bx, tmp_string
call obter_data
mov si, bx
call escrever
	
mov si, espaco
call escrever

mov ah, 02h
int 90h

;;************************************************************
   
obter_horario:
	
pusha

mov di, bx			

clc				
mov ah, 2			
int 1Ah

jnc .ler

clc
mov ah, 2			
int 1Ah

.ler:

mov al, ch	
		
call BCD_para_Inteiro

mov dx, ax			

mov al,	ch			
shr al, 4			
and ch, 0Fh			
	
test byte [fmt_12_24], 0FFh
jz .doze_horas

call .adc_digito	
	
mov al, ch
	
call .adc_digito
	
jmp short .minutos

.doze_horas:

cmp dx, 0			
je .meianoite

cmp dx, 10			
jl .doze_st1

cmp dx, 12			
jle .doze_st2

mov ax, dx			
sub ax, 12
mov bl, 10
div bl
mov ch, ah

cmp al, 0		
je .doze_st1

jmp short .doze_st2		

.meianoite:

mov al, 1
mov ch, 2

.doze_st2:

call .adc_digito	
		
.doze_st1:

mov al, ch
call .adc_digito

mov al, ':'			
stosb

.minutos:

mov al, cl			
shr al, 4			
and cl, 0Fh			
call .adc_digito
mov al, cl
call .adc_digito

mov al, ' '			
stosb

mov si, .string_de_hora		
	
test byte [fmt_12_24], 0FFh
jnz .copia

mov si, .pm_string	
	
cmp dx, 12			
jg .copia

mov si, .am_string		

.copia:

lodsb				
stosb
	
cmp al, 0
jne .copia

popa
ret

.adc_digito:

add al, '0'			
stosb			
ret


.string_de_hora	db 'horas', 0
.am_string 	db 'da manha',10,13, 0
.pm_string 	db 'da tarde/noite',10,13, 0

;;************************************************************

obter_data:
	
pusha

mov di, bx			
mov bx, [formato_data]		
and bx, 7F03h		

clc				
mov ah, 4			
int 1Ah

jnc .ler

clc
mov ah, 4			
int 1Ah

.ler:

cmp bl, 2			
jne .tentar_formato1

mov ah, ch		
	
call .adicionar_dois_digitos
	
mov ah, cl
	
call .adicionar_dois_digitos	
	
mov al, '/'
stosb

mov ah, dh	
	
call .adicionar_dois_digitos
	
mov al, '/'			
stosb

mov ah, dl			
	
call .adicionar_dois_digitos
	
jmp short .pronto

.tentar_formato1:

cmp bl, 1			
jne .fazer_formato0

mov ah, dl			
call .adicionar_1ou2Digitos

mov al, bh
cmp bh, 0
jne .formato1_dia

mov al, ' '			

.formato1_dia:

stosb				

mov ah,	dh	
	
cmp bh, 0			
jne .formato1_mes

call .adicionar_mes			
mov ax, ', '
	
stosw
	
jmp short .formato1_seculo

.formato1_mes:

call .adicionar_1ou2Digitos		
	
mov al, bh
stosb

.formato1_seculo:

mov ah,	ch	
	
cmp ah, 0
je .formato1_ano

call .adicionar_1ou2Digitos		

.formato1_ano:

mov ah, cl			
call .adicionar_dois_digitos		

jmp short .pronto

.fazer_formato0:
			
mov ah,	dh	
	
cmp bh, 0			
jne .formato0_mes

call .adicionar_mes	
	
mov al, ' '
stosb
	
jmp short .formato0_dia

.formato0_mes:

call .adicionar_1ou2Digitos
	
mov al, bh
stosb

.formato0_dia:

mov ah, dl		
call .adicionar_1ou2Digitos

mov al, bh
cmp bh, 0			
jne .formato0_dia2

mov al, ','			
stosb
mov al, ' '

.formato0_dia2:

stosb

.formato0_seculo:

mov ah,	ch	
	
cmp ah, 0
je .formato0_ano

call .adicionar_1ou2Digitos		

.formato0_ano:

mov ah, cl			
call .adicionar_dois_digitos		


.pronto:

mov ax, 0		
stosw

popa
ret


.adicionar_1ou2Digitos:

test ah, 0F0h
jz .apenas_um
	
call .adicionar_dois_digitos
	
jmp short .apenas_dois
	
.apenas_um:

mov al, ah
and al, 0Fh
	
call .adc_digito
	
.apenas_dois:

ret

.adicionar_dois_digitos:

mov al, ah			
shr al, 4
	
call .adc_digito
	
mov al, ah
and al, 0Fh
	
call .adc_digito
	
ret

.adc_digito:

add al, '0'			
stosb				
ret

.adicionar_mes:

push bx
push cx
mov al, ah	
	
call BCD_para_Inteiro
	
dec al			
mov bl, 4		
mul bl
mov si, .meses
add si, ax
mov cx, 4
	
rep movsb
	
cmp byte [di-1], ' '		
jne .pronto_mes_data
	
dec di
	
.pronto_mes_data:

pop cx
pop bx
ret


.meses db 'Jan.Fev.Mar.Abr.Mai JunhoJulhoAgo.SetOut.Nov.Dez.'

;;************************************************************
	
BCD_para_Inteiro:
	
pusha

mov bl, al		

and ax, 0Fh			
mov cx, ax		

shr bl, 4		
mov al, 10
mul bl				

add ax, cx		
mov [.tmp], ax

popa
mov ax, [.tmp]			
ret

.tmp	dw 0

;;************************************************************

fmt_12_24	db 0		

formato_data	db 0, '/'	
	
tmp_string		times 15 db 0
	
	
horas_msg db 10,13,"Horario de agora:",10,13,0	
data_msg db 10,13,"Data de hoje:",10,13,0
espaco db 10,13,10,13,0