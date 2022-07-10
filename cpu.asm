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

;;***********************************************************************************
;;
;;
;; Sistema de Gerenciamento de Hardware do PX-DOS® 0.9.0
;;
;; Detector de Processador e Recursos para o PX-DOS
;;
;; Este programa possui código para Aplicativo e código para Driver do PX-DOS
;;
;;***********************************************************************************

%ifdef Driver

%include "C:\Dev\ASM\Driver\driver.s"

%endif

%ifndef Driver

%include "C:\DEV\ASM\APPX\APPX.s"

%endif

mov ax, cs
mov bx, ax
mov cx, ax
mov dx, ax
mov es, ax
mov fs, ax
mov gs, ax

%ifndef Driver

jmp Verificar

%endif

%ifdef Driver

jmp inicio

%endif

%ifndef Driver

%include "C:\DEV\ASM\gui.s"

%define _Interface_APP_
%define INTERFACE

col equ 80

lin equ 25

%endif

;;************************************************************

VERSAO equ 0
SUBVERSAO equ 9

Verificar:

mov ah, 13h
int 90h

cmp ax, VERSAO
je near Continua

jmp FIMVDI

;;************************************************************

Continua:

cmp bx, SUBVERSAO
je near inicio

jmp FIMVDI

;;************************************************************

FIMVDI:

print 10,13,"Versao incorreta do PX-DOS ou DOS",10,13,0

mov ah, 02h
mov bx, 1h
int 90h

;;************************************************************

inicio:	

call clrscr

;;************************************************************

BoasVindasPausa:

call clrscr
jmp BoasVindas

;;************************************************************

BoasVindas:
    
	
mov dx, boasVindas	
mov ah, 9
int 21h

; Testar se é um 386 ou superior

pushf  
mov byte [familia], 0	; 808x ou 186
	
xor ax, ax
push ax
popf	; Tenta limpar todos os bits
pushf
pop ax
		
and ax, 0f000h
	
cmp ax, 0f000h
jnz e286	
	
mov ax, 1
mov cl, 64	
shr ax, cl
or ax, ax
	
jz e086	; 186 ignora o bit mais significativo de cl
	
mov byte [familia],1

;;************************************************************
	
e086:	

jmp short semCPUID

;;************************************************************

e286:
	
mov byte [familia], 2	
mov ax, 0f000h

push ax
popf	
pushf
pop ax

test ax, 0f000h
jz semCPUID	
	
mov byte [familia],3	

pushfd		; Recuperar EFLAGS
pushfd
pop eax
mov ebx, eax
xor eax, 200000h	
		
push eax
popfd
pushfd
pop eax
popfd		; Recuperar EFLAGS
	
xor eax, ebx			
test eax, 200000h		
jnz possuiCPUID	; Possui CPUID

mov ebp, esp
and sp, 0fff0h	
mov esp, ebp
pushfd		
pushfd
pop eax
mov ebx, eax
xor eax, 40000h		
		
push eax
popfd
pushfd
pop eax
		
popfd	
	
xor eax, ebx	
	
test eax, 40000h			
jz naoE486		
	
mov byte [familia],4	
	
;;************************************************************

naoE486:		

cld
mov si,81h	
	
;;************************************************************
	
linhaDeComando:

lodsb
	
cmp al, 13	
jz semCPUID
	
or al, 20h	
	
cmp al, 'i'	
jz possuiCPUID
	
jmp short linhaDeComando

;;************************************************************
	
semCPUID:	

popf		

call descrevernivel
	
cmp byte [familia], 3	
jb idlivre
	
mov dx, naoCPUID	
mov ah,9
int 21h

;;************************************************************
	
idlivre:	

jmp pronto_CPU	; Nada mais a chamar

;;************************************************************

possuiCPUID:	

popf		
xor eax, eax	
cpuid		
mov [cpuidlevel], eax	
cld
mov di, marca	
mov eax, ebx
stosd
mov eax, edx
stosd
mov eax, ecx
stosd

cmp dword [cpuidlevel], byte 1
jnb id1
	
mov byte [vendcut], '$'	
mov dx, msg_marca	
mov ah, 9
int 21h
	
mov dx, msg_marca2
mov ah,9
int 21h
	
jmp naotipo1	; Impossível mostrar tipo/famólia/marca

;;************************************************************
	
id1:	

mov eax, 1
cpuid		; CPUID - busca de código 1
mov [um_a], eax
mov [um_b], ebx
mov [um_c], ecx
mov [um_d], edx

mov byte [rev], al
mov byte [modelo], al
and word [rev], 15
shr word [modelo], 4
and word [modelo], 15
and ah, 15
mov byte [familia], ah
and word [familia], 15

mov bx, [familia]
mov al, [digitoshexa+bx]
mov [famchar], al
mov bx, [modelo]
mov al, [digitoshexa+bx]
mov [modchar], al
mov bx, [rev]
mov al, [digitoshexa+bx]
mov [revchar], al

mov dx,msg_marca	
mov ah,9
int 21h

	
mov di, id1str
mov eax, [um_a]
	
call paraHex
	
inc di
mov eax, [um_b]
	
call paraHex
	
inc di
mov eax, [um_c]
	
call paraHex
	
inc di
mov eax, [um_d]
	
call paraHex

mov dx, id1msg	
mov ah,9
int 21h

mov dx, lista_recursos_EDX	
mov ah,9
int 21h
	
mov eax, [um_d]
mov si, nome_bits_EDX
	
call bits_descrever
	
mov eax, [um_c]
	
or eax, eax
jz nao_ecx
	
mov dx, lista_recursos_ECX	
mov ah,9
int 21h
	
mov eax, [um_c]
mov si, nomesECX
call bits_descrever

;;************************************************************
	
nao_ecx:	

jmp short bits_pronto

;;************************************************************

bits_descrever:

xor ecx, ecx
xor bx, bx
	
;;************************************************************
	
b_loop:	

bt eax, ecx	
jnc b_off

inc bx		
push eax

mov dx, bits_cabecalho_msg
mov ah, 9
int 21h

mov dx, [cs:si]	
mov ah,9
int 21h

pop eax
test bx, 3
jnz b_linha

push eax

mov dx, crlfmsg	
mov ah,9
int 21h

pop eax

;;************************************************************

b_linha:

;;************************************************************

b_off:	

inc cx
add si, 2
	
cmp cx, 32	
jb b_loop
	
mov dx, crlfmsg	
mov ah,9
int 21h
	
ret

;;************************************************************

bits_pronto:

mov eax, 80000000h	
cpuid
push eax
	
cmp eax, 80000001h
jb short naoXmin

;;************************************************************

idx1:	

mov eax, 80000001h
cpuid		
mov [um_a], eax
mov [um_b], ebx
mov [um_c], ecx
mov [um_d], edx

mov di, idx1str
mov eax, [um_a]
	
call paraHex
	
inc di
mov eax, [um_b]
	
call paraHex
	
inc di
mov eax, [um_c]
	
call paraHex
	
inc di
mov eax, [um_d]
	
call paraHex

mov dx, idx1msg
mov ah, 9
int 21h

;;************************************************************

naoXmin:

pop eax

cmp eax, 80000004h	
jb near naoXid	
	
cmp eax, 80000100h
ja near naoXid

mov dx, x_checar_msg
mov ah, 9
int 21h

mov eax, 80000001h
cpuid

test edx, 0e0000000h
jz sem3d

test edx, 80000000h
jz nao3d

push edx

mov dx, msg3dnow
mov ah, 9
int 21h

pop edx

;;************************************************************

nao3d:

test edx, 40000000h
jz nao3d2

mov dx, msg3dnow2
mov ah, 9
int 21h

;;************************************************************

nao3d2:  

test edx, 20000000h
jz nao3d3

mov dx, msgath64
mov ah,9
int 21h

;;************************************************************

nao3d3:	

mov dx, crlfmsg
mov ah, 9
int 21h
	
jmp short nomeCPU

;;************************************************************

sem3d:	

mov dx, x_checar_msg2
mov ah, 9
int 21h	

;;************************************************************

nomeCPU:
			
mov eax, 80000002h	
cpuid
mov di, produto		
stosd
mov eax, ebx
stosd
mov eax, ecx
stosd
mov eax, edx
stosd
mov eax, 80000003h	
cpuid
stosd
mov eax, ebx
stosd
mov eax, ecx
stosd
mov eax, edx
stosd
mov eax, 80000004h	
cpuid
stosd
mov eax, ebx
stosd
mov eax, ecx
stosd
mov eax, edx
stosd

mov si, produto		
mov cx, 48

;;************************************************************

p_loop:	

lodsb
cmp al, ' '
jae isprn

mov al, '_'

;;************************************************************

isprn:

mov [si-1], al
loop p_loop

mov dx, prodmsg		
mov ah,9
int 21h

;;************************************************************
	
naoXid:

;;************************************************************

naotipo1:

;;************************************************************

pronto_CPU:

mov al, [cs:familia]	
mov ah, 4ch	
int 21h

;;************************************************************

descrevernivel:

xor bx, bx
mov bl, [cs:familia]

cmp bl, 7
jbe normf

mov bl,8

;;************************************************************
	
normf:	

add bx, bx
add bx, familias	
	
mov dx, [cs:bx]	
mov ah, 9	
int 21h
	
mov dx, famtail
mov ah, 9
int 21h
	
ret

;;************************************************************

paraHex:	

push eax
push bx
push cx
mov cx,8

;;************************************************************

hloop:

rol eax, 4
mov bx, ax
and bx, 15
mov bh, [cs:digitoshexa+bx]
mov [cs:di], bh
inc di
loop hloop
pop cx
pop bx	
pop eax

ret

;;************************************************************

boasVindas	db 10,13,"Gerencimento de Hardware do PX-DOS(R)"
		db 10,13,"$"

digitoshexa	db "0123456789abcdef"

msg_marca	db "Marca do Processador: "
marca	db "abcdabcdabcd"
vendcut	db " / Familia do Processador: "
famchar	db "0 modelo "
modchar	db "0 revisao "
revchar	db "0",13,10,"$"
msg_marca2	db 13,10
	db "Familia / modelo / revisao desconhecidas!",13,10,"$"

prodmsg	db "Nome do Processador: ["
produto	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",13,10,"$"

id1msg	db 13,10
	db 9,"CPUID Nivel 1 EAX_.... EBX_.... ECX_.... EDX_....",13,10
	db 9,"  Valores: "
id1str	db "00000000 00000000 00000000 00000000",13,10,"$"

idx1msg	db 13,10
	db 9,"Nivel +1 EAX_.... EBX_.... ECX_.... EDX_....",13,10
	db 9,"  Valores: "
idx1str	db "00000000 00000000 00000000 00000000",13,10,"$"

x_checar_msg	db "Recursos exclusivos da AMD:$"
x_checar_msg2	db " [vazio]"
crlfmsg		db 13,10,"$"

		
msg3dnow	db " [3DNow!]$"		; bit 31
msg3dnow2	db " [ext 3DNow!]$"	; bit 30
msgath64	db " [64bit AMD]$"	; bit 29 "Long Mode, AA-64"
		

naoCPUID	db "Este processador nao suporta a instrucao CPUID, necessaria a identificacao. -"
	db 10,13," Use a opcao /i para tentar de novo.",13,10,"$"
famtail	db " Processador encontrado.",13,10,"$"

familias	dw x86, x186, i286, i386, i486, pent, ppro, cpu64, xeon

x86	db "8086 ou compativel 16bit$"
x186	db "80186 ou compativel 16bit$"
i286	db "80286 (16bit com modo protegido)$"
i386	db "i386 ou compativel$"

i486	db "i486 ou compativel$"	
pent	db "Classe Pentium$"		
ppro	db "Pentium Pro ou mais novo$"
cpu64	db "Intel Itanium IA64 ou similar 64bit$"
xeon	db "Intel Xeon ou servidor similar$"

lista_recursos_EDX	db "CPUID Nivel 1 em EDX:",13,10,"$"
lista_recursos_ECX	db 13,10,"CPUID Nivel 1 em ECX:",13,10,"$"

nome_bits_EDX	dw fpu, vme, dbe, pse, tsc, msr, pae, mce
		dw c8b, apic, asys, isys, mtrr, gp, mca, cmov
		dw pat, pse2, serno, clf, x20, dts, acpi, mmx
		dw fxsr, sse, sse2, ssnoop, hthread, acc, ia64, pbe

nomesECX	dw sse3, y01, y02, mwt, dscpl, vmxe, smxe, sstep
		dw acc2, sse3b, ccache, y11, y12, c16b, etrpd, perfm
		dw y16, y17, dcache, sse41, sse42, xapic, y22, popc
		dw y24, y25, y26, y27, y28, y29, y30, y31

bits_cabecalho_msg	db "  [$"	
	
fpu	db "PONTO FLUTUANTE] $"
vme	db "VM EXT FLAGS]   $"	
dbe	db "EXT DEBUG]      $"	
pse	db "TAMANHO DA PAGINA] $"
tsc	db "TIMESTAMP COUNT]$"
msr	db "Pentium MSR]    $"
pae	db "PAE 36bit] $"
mce	db "MCE]  $"	

c8b	db "cmpxchg8b op]   $"
apic	db "APIC presente]   $"
asys	db "AMD SYSCALL]    $"	
isys	db "SYSENTER/-EXIT] $"
mtrr	db "MTRR presente]   $"	
gp	db "PAGINAS GLOBAIS]   $"
mca	db "mca]            $"	
cmov	db "Opcode CMOV]    $"

pat	db "Tabela de paginas]$"
pse2	db "4 MB PSE]       $"	
serno	db "Numero serial]  $"	
clf	db "cacheline flush]$"
x20	db "bit 20?]        $"
dts	db "Dbug]    $"	
acpi	db "Termal ACPI]   $"	
mmx	db "Unidade MMX]       $"

fxsr	db "FXSAVE/restaurar] $"
sse	db "Unidade SSE]       $"
sse2	db "Unid. SSE2]      $"
ssnoop	db "self snoop]     $"
hthread	db "HyperThreading] $"	
acc	db "therm. throttle]$"	
ia64	db "CPU 64-Bit] $"	
pbe	db "PBE / STPCLK]   $"	

	

sse3	db "Unidade SSE3]      $"
y01	db "bit 1?]         $"
y02	db "bit 2?]         $"
mwt	db "MWAIT]          $"
dscpl	db "CPL]$"	
vmxe	db "VMXE]           $"	
smxe	db "SMXE]           $"	
sstep	db "SpeedStep]  $"

acc2	db "TM2E]   $"	
sse3b	db "SSE3 ext]       $"	
ccache	db "cachecontext ID]$"
y11	db "bit 11?]        $"
y12	db "bit 12?]        $"
c16b	db "cmpxchg16b op]  $"
etrpd	db "etprd]          $"	
perfm	db "perf debug MSR] $"	

y16	db "bit 16?]        $"
y17	db "bit 17?]        $"	
dcache	db "MMIO cache]     $"	
sse41	db "SSE4.1]         $"
sse42	db "SSE4.2]         $"
xapic	db "x2APIC]         $"	
y22	db "bit 22?]        $"	
popc	db "populationcount]$"

y24	db "bit 24?]$"		; ...
y25	db "bit 25?]$"		; ...
y26	db "bit 26?]$"		; ...
y27	db "bit 27?]$"		; ...
y28	db "bit 28?]$"		; ...
y29	db "bit 29?]$"		; ...
y30	db "bit 30?]$"		; ...
y31	db "bit 31?]$"		; ...

	

um_a	dd 0	; CPUID EAX 0FFMtfmr
um_b	dd 0	; CPUID EBX AALLCCBB
um_c	dd 0	; CPUID ECX velocidade / SSE3 / thermal...
um_d	dd 0	; CPUID EDX feature bit mask

familia	dw 0
modelo	dw 0
rev	dw 0

cpuidlevel	dd 0
xcpuidlevel	dd 0

