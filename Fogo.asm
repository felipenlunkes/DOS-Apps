;;**************************************************************
;;
;;
;; Proteção de Tela para PX-DOS 0.9.0 ou superior
;;
;;
;;
;; Copyright © 2014 Felipe Miguel Nery Lunkes
;;
;;
;;
;;
;;**************************************************************

.MODEL TINY
.386
.CODE
ORG 100h

;;**************************************************************

Principal:

                mov     al, 13h
                int     10h

                xor     ax, ax

                mov     di, offset chamas
                mov     cx, (Altura_chama*Largura_Chama)
                rep     stosw

                mov     dx, 3c8h
                out     dx, al
                inc     dx

                dec     cl
				
;;**************************************************************
				
checar_vermelho:

                cmp     bl, 60
                jae     checar_verde
                add     bl, 4
                jmp     checar_numero
				
;;**************************************************************
				
checar_verde:

                cmp     bh, 60
                jae     checar_numero
                add     bh, 4

;;**************************************************************

checar_numero:

                mov     al, bl
                out     dx, al
                mov     al, bh
                out     dx, al
                xor     al, al
                out     dx, al
                loop    checar_vermelho

;;**************************************************************
				
fazer_fogo:        

mov     cl, FLocal

colocar_local:

                add     [semente], 62e9h
                add     byte ptr [semente], 62h
                adc     [semente+2], 3619h

                mov     ax, [semente+2]
                xor     dx, dx
                mov     bx, Largura_Chama
                div     bx

                mov     si,dx
                dec     byte ptr [chamas+((Altura_chama-1)*Largura_Chama)+si]
                loop    colocar_local


                mov     si, offset chamas+1+Largura_Chama
                mov     di, offset novas_chamas+1

                mov     cl, Altura_chama-2
				
;;**************************************************************
				
coluna:     

   mov     dx, Largura_Chama-2

;;**************************************************************

linha:

                mov     bl, [si-Largura_Chama]

                mov     al, [si-1]
                add     bx, ax

                mov     al, [si+1]
                add     bx, ax

                mov     al, [si+Largura_Chama]
                add     bx, ax

                shr     bx, 2
                mov     [di], bl

                inc     si
                inc     di
                dec     dx
                jnz     linha

                inc     si
                inc     si
                inc     di
                inc     di
                loop    coluna

                mov     si, offset novas_chamas+2
                mov     di, offset chamas+2
                mov     cx, Largura_Chama*Altura_chama/2-2
                push    cx
                push    di
                rep     movsw

                pop     si

                push    0a000h
                pop     es

                mov     di, (200-Altura_chama)*320+((320-Largura_Chama)/2)+2
                pop     cx
                rep     movsw

                push    ds
                pop     es

                mov     ah, 1
                int     16h
                jz      fazer_fogo
				
;;**************************************************************

Tecla_Pressionada:
				
                mov     ax,3
                int     10h
                ret

;;**************************************************************
				
Altura_chama             =       100
Largura_Chama             =       320
FLocal           =       200
semente        dw      ?,?
chamas          db      (Largura_Chama*Altura_chama) dup (?)
novas_chamas      db      (Largura_Chama*Altura_chama) dup (?)

END Principal