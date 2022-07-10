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

;;**************************************************************************************
;;
;;
;;        Servidor de Execução de aplicativos no formato APPX para PX-DOS®
;;
;;
;;   Este aplicativo fornece funções para a liberação de recursos para a execução
;;          de aplicativos no formato APPX dependentes da arquitetura
;;
;;               
;;
;;                 Copyright © 2014-2016 Felipe Miguel Nery Lunkes
;;                          Todos os direitos reservados
;;
;;**************************************************************************************
;;
;;                        Módulo de Gerenciamento de Processador
;;
;;  Este arquivo contém funções necessárias para verificar recursos do processador,
;;     ativá-los e torná-los disponíveis aos programas e ao Sistema Operacional
;;
;;
;;**************************************************************************************
 
 [BITS 16]

 use16
 
 org 100h
 
 cpu 586

 %define __TEXTO__ [SECTION .text] 
 %define __DATA__ [SECTION .data] 
 %define __BSS__ [SECTION .bss]
 
 mov ax, cs
 mov bx, ax
 mov cx, ax
 mov es, ax
 mov fs, ax
 mov gs, ax
 
 jmp Verificar
 

%include "C:\Dev\ASM\video.s"
%include "C:\Dev\ASM\tempo.s"
%include "C:\Dev\ASM\versao.s"

__TEXTO__

;;************************************************************

Verificar:

call verificar_sistema

;;************************************************************

inicio:

print 10,13,"Servico de Gerenciamento de Executaveis no formato APPX(R)",10,13,0
print 10,13,"Sistema Operacional PX-DOS(R) "
call detectar_sistema_atual
print "",10,13,10,13,0
print "Copyright (C) 2016 Felipe Miguel Nery Lunkes",10,13,10,13,0

print "Iniciando suporte APPX(R) em modo de arquitetura generica...",10,13,0
print "Requer 186 ou superiores, para o uso do modo de arquitetura generica.",10,13,0

call VERIFICAR_X86

print 10,13,"",0

mov ah, 02h
mov bx, 01h
int 90h

;;**************************************************************************************

Ativar_A20: ;; Ativa a linha A20


        cli
 
        call    aguardarA20
        mov     al,0xAD
        out     0x64,al
 
        call    aguardarA20
        mov     al,0xD0
        out     0x64,al
 
        call    aguardarA20_2
        in      al,0x60
        push    eax
 
        call    aguardarA20
        mov     al,0xD1
        out     0x64,al
 
        call    aguardarA20
        pop     eax
        or      al,2
        out     0x60,al
 
        call    aguardarA20
        mov     al,0xAE
        out     0x64,al
 
        call    aguardarA20
        sti
		
		print 10,13,"## A20 habilitado.",0
		
		
        ret
 
aguardarA20:

        in      al,0x64
        test    al,2
        jnz     aguardarA20
        ret
 
 
aguardarA20_2:

        in      al,0x64
        test    al,1
        jz      aguardarA20_2
        ret

.nao:

print "!! A20 nao habilitado.",0



		
;;**************************************************************************************
		
VERIFICAR_X86:


print 10,13,"-> Verificando suporte do processador para o sistema...",0

mov ax, 6
call delay

pushfd   
              
pop eax                
mov ebx, eax    
        
xor eax, 00200000h      ; Ativa o bit 21

push eax   
           
popfd                   ; Devolver valores da pilha aos registradores

pushfd 
                
pop eax   
             
cmp eax, ebx
jnz @CPUID_SUPORTADO    ; Suporta esta função
	

	
print 10,13,"!! Desculpe, mas seu processador nao pode ser identificado.",0
print 10,13,"!! Este processador nao e suportado completamente pelo sistema.",10,13,0
print "!! Fechando Diagnostico de Sistema...",10,13,10,13,0

ret
 
;;************************************************************************************** 
 
@CPUID_SUPORTADO:




call Ativar_A20

print " -> Este processador suporta a instrucao CPUID corretamente.",0

         mov eax,0
         CPUID     
		 
         mov [edi+0],eax 
		 
         add edi,4
		 
         mov [edi+0],ebx
		 
         mov [edi+4],edx
		 
         mov [edi+8],ecx
		 
         mov [edi+12],byte 0       

         add edi,16

 ;; Checagem de MMX

         mov EAX,1
		 
         CPUID
		 
         mov ebx,edx
		 
         and ebx,0x800000
		 
         shr ebx,23
		 
         mov [edi+0],bl            ;; MMX Suportado?
		 
		
		 
          print 10,13,"-> Este processador suporta instrucoes MMX.",0
		 
         add edi,1

 ;; Checar 3DNow!

         mov [edi+0],byte 0
		 
         mov eax, 0x80000001       ;; Nivel Extendido 1
		 
         CPUID
		 
         test edx, 0x80000000
		 
         jz @sem_3DNOW
		 
         mov [edi+0],byte 1        ;; 3DNOW! Suportado
		 
		
		 
		 print 10,13,"-> O Processador atual possui tecnologia 3DNow!, da AMD.",10,13,0
		 
		 call BANDEIRA
		 
		 ret
		 
         @sem_3DNOW:
        
		 
		 
		 print 10,13,"-> O Processador atual nao possui tecnologia 3DNow!, da AMD.",10,13,0
		  
         add edi,1

         mov eax, 0x80000000
		 
         CPUID
		 
         mov [edi+0],eax
		
        call BANDEIRA
		
		ret

;;**************************************************************************************		
BANDEIRA:


    mov eax,80000002h	
	cpuid
	
	mov di,produto		
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000003h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000004h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	mov si,produto		
	mov cx,48
	
loop_CPU:	

    lodsb
	cmp al,' '
	jae imprimir_CPU
	mov al,'_'
	
imprimir_CPU:	

    mov [si-1],al
	loop loop_CPU

	mov dx,prodmsg		
	mov ah,3h
	int 90h

	
	
	
mov eax, 0x0
cpuid

mov [ processador_global ], ebx
mov [ processador_global + 4 ], edx
mov [ processador_global + 8 ], ecx





print 10,13,"## Fabricante do processador atualmente instalado: ", 0

mov si, processador_global
call escrever

print 10,13,10,13,"Servicos extendidos APPX(R) iniciados.",0
print 10,13,"Suporte a nivel de arquitetura: 7.",10,13
print "Saiba mais sobre nivel de arquitetura no SDK do PX-DOS(R).",0

xor ax, ax

mov ax, 200h
mov bx, processador_global

mov [200h], bx


ret

;;**************************************************************************************

;; .data



processador_global times 13 db 0
		
INTEL db "GenuineIntel",0

AMD db "AuthenticAMD", 0
		
SIS db "SiS SiS SiS ", 0

prodmsg	db "-> Nome do Processador: ["

produto	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",13,10,"$"


__DATA__

ARQUITETURA: db 7
HAL: dw "\DRIVERS\HAL.SIS",0
Pasta_APPX: db "\apps\appx\",0

;;***********************************
;;
;; Chaves
;;
;;***********************************


abertura_appx: db "<?APPX",0
fechamento_appx: db "?>",0
abertura_nome: db "<NOME>",0
fechamento_nome: db "</NOME>",0
abertura_arquitetura: db "<ARQUITETURA>",0
fechamento_arquitetura: db "</ARQUITETURA>",0
abertura_inf: db "<INF>",0
fechamento_inf: db "</INF>",0
abertura_desenvolvedor: db "<DESENVOLVEDOR>",0
fechamento_desenvolvedor: db "</DESENVOLVEDOR>",0
abertura_copy: db "<COPYRIGHT>",0
fechamento_copy: db "</COPYRIGHT>",0
abertura_influencia: db "<USO>",0
fechamento_influencia: db "</USO>",0
abertura_nivel: db "<PROCESSADOR>",0
fechamento_nivel: db "</PROCESSADOR>",0
abertura_plataforma: db "<PLATAFORMA>",0
fechamento_plataforma: db "</PLATAFORMA>",0
abertura_dependencia: db "<DEPENDENCIA>",0
fechamento_dependencia: db "</DEPENDENCIA>",0
abertura_metadata: db "<METADATA>",0
fechamento_metadata: db "</METADATA>",0
abertura_inf_sis: db "<INFLUENCIA>",0
fechamento_inf_sis: db "</INFLUENCIA>",0
abertura_cpu: db "<CPU>",0
fechamento_cpu: db "</CPU>",0
abertura_se: db "<SE>",0
fechamento_se: db "</SE>",0
abertura_disquete: db "<DISQUETE>",0
fechamento_disquete: db "</DISQUETE>",0
abertura_declarar: db "<DECLARAR>",0
fechamento_declarar: db "</DECLARAR>",0
abertura_var: db "<VAR>",0
fechamento_var: db "</VAR>",0
abertura_entao: db "<ENTAO>",0
fechamento_entao: db "</ENTAO>",0
abertura_exec: db "<EXEC>",0
fechamento_exec: db "</EXEC>",0
abertura_pic: db "<PIC>",0
fechamento_pic: db "</PIC>",0
abertura_hd: db "<HD>",0
fechamento_hd: db "</HD>",0
abertura_pendrive: db "<PENDRIVE>",0
fechamento_pendrive: db "</PENDRIVE>",0


erro_dependencia: db 10,13,"Erro. A dependencia citada nao foi localizada.",10,13,0
erro_linha: db 10,13,"Erro na linha: 0",10,13,0
arquivo_manifesto: db "\apps\appx\mnfst.app",0

PARAMETROS: dw ":APPX =7",0
AUTOR: db "Felipe Miguel Nery Lunkes",0

__BSS__

