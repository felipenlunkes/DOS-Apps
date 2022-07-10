/*

Biblioteca de Funções em C para PX-DOS® 0.9.0

Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes

*/

#define NULL ((void *)0)

char libver(void); 
void contarnatela(int inicial, int final); 
void morrer(int imprimir); 
char sisver(void);
char readln(void); 
void writeln(char imprimir); 
long pot(int a, int b); 
int par(int numero); 
void linha(void); 
void linhas(int numero);
int cls(void); 
int contar(int inicial, int final); 
int soma(int a, int b); 
int subtracaoa(int a, int b); 
void esperar(void);
int subtracaob(int a, int b); 
long mult(long a, long b); 
void autor(void); 
void versaolib(void); 
extern __escrever;
char versaosistema[80];
asm { extrn __clrscr }
asm { extrn __emitirsom }
asm { extrn __desligarsom }
void finalizar(int erro);
int errorlevel(void);
void limparerrorlevel(void);
int compararString(char *um, char *dois);
void reiniciar(int metodo);
int pxerrno=0;
int errnoglobal=0;
unsigned int *vidmem = 0xb800;
int *mem = 0x100;
asm { extrn __mem };
void pausa(char mensagem); 
unsigned int *mempos = 32760;

typedef int integer;
typedef char string;
typedef unsigned int intna;

// Variáveis globais que poderão ser acessadas pelo programa
string compilacao[256]="2.6.0.1";
int versao_lib=010;
long versao_completo=0.1;
string *suporte="Lib C 1.0.Beta6";
// Fim das variáveis globais

char libver(void){
string *lib[256];
string *libcopy[256];
lib[256]="Biblioteca C desenvolvida por Felipe Miguel versao 0.9.0";
libcopy[256]="Copyright (C) 2016 Felipe Miguel Nery Lunkes";
return *lib[256];
return *libcopy[256];
}

void esperar(void){
asm{

mov ax, 0
int 16h
}
}

void pausa(char mensagem){

if (mensagem == NULL){
printf("\nPressione qualquer tecla para continuar...\n");
printf("\n%s\n",mensagem);
asm{

mov ax, 0
int 16h
}
}
}

void contarnatela(int inicial, int final){
int x;

for (x=inicial;x<=final;x++){
printf("\nValor atual de 'X': %d", x);
}

}

char sisver(void){

sprintf(versaosistema[80], "PX-DOS 0.9.0");

return (versaosistema[80]);
}

void morrer(int imprimir){

if ( imprimir <= 5 ) {
printf("O programa retornou o codigo: %d", imprimir);
errnoglobal=imprimir;
}
else {
printf("O programa retornou um codigo de erro inesperado.");
printf("\nCodigo de erro detalhado: %d", imprimir);
errnoglobal=imprimir;
}

}

char readln(void){

char *tmp[256];
scanf("%s",*tmp[256]);
return (*tmp[256]);

}

void writeln(char imprimir){

printf("%s", imprimir);

}

long pot(int a, int b){

long ret;

if (b == 2) {
ret=a*a;
}
if (b == 3) {
ret=a*a*a;
}
if (b == 4) {
ret=a*a*a*a;
}
if (b == 5) {
ret=a*a*a*a*a;
}
if (b == 6) {
ret=a*a*a*a*a*a;
}
if (b == 7) {
ret=a*a*a*a*a*a*a;
}
if (b == 8) {
ret=a*a*a*a*a*a*a*a;
}
if (b == 9) {
ret=a*a*a*a*a*a*a*a*a;
}
if (b == 10) {
ret=a*a*a*a*a*a*a*a*a*a;
}
if (b == 11) {
ret=a*a*a*a*a*a*a*a*a*a*a;
}

return (ret);
}

void reiniciar(int metodo){

if (metodo == 1 | metodo == 0 ){

if (metodo = 0){

asm {

int 19h

} } else {

asm {

mov ah, 0x04
int 90h
}

}


}



}


int par(int numero){

if (numero%2 == 0 ) {

return 0;

}
else {

return 1;

}
}

void linha(void){
printf("\n");
}

void linhas(int numero){

if ( numero == 2) {
printf("\n\n");
}
if ( numero == 3) {
printf("\n\n\n");
}
if ( numero == 4) {
printf("\n\n\n\n");
}
if ( numero == 5) {
printf("\n\n\n\n\n");
}
if ( numero == 6) {
printf("\n\n\n\n\n\n");
}
if ( numero == 7) {
printf("\n\n\n\n\n\n\n");
}
if ( numero == 8) {
printf("\n\n\n\n\n\n\n\n");
}
if ( numero == 9) {
printf("\n\n\n\n\n\n\n\n\n");
}
if ( numero == 10) {
printf("\n\n\n\n\n\n\n\n\n\n");
}
}

int cls(void){

asm {
push ax
push bx
push cx
push dx


mov dx, 0
mov bh, 0
mov ah, 2
int 10h

mov ah, 6
mov al, 0
mov bh, 7
mov cx, 0
mov dh, 24
mov dl, 79
int 10h


pop dx
pop cx
pop bx
pop ax

}
}

int contar(int inicial, int final){

int total=0;
total=final-inicial;
return (total);

}

int errorlevel(void){

pxerrno+=1;

if (errnoglobal != 0 ){
pxerrno=errnoglobal;
}
else {
pxerrno=pxerrno;
}
return pxerrno;
}


int soma(int a, int b){

int total;
total=a+b;
return (total);

}

int subtracaoa(int a, int b){

int total;
total=a-b;
return (total);
}

int subtracaob(int a, int b){
int total;
total=b-a;
return (total);
}

long mult(long a, long b){

long total;
total=a*b;
return (total);

}

void autor(void){

printf("\nDesenvolvido por Felipe Miguel Nery Lunkes\n");

}

int compararString(char *um, char *dois)
{
    while (paramaiusculo(*um) == paramaiusculo(*dois))
    {
        if (*um == '\0')
        {
            return (0);
        }
        um++;
        dois++;
    }
    if ((*um) < paramaiusculo(*dois))
    {
        return (-1);
    }
    return (1);
}


void versaolib(void){

printf("\nPXLibC versao 1.0.Beta6 para PX-DOS(R)\n\nOutros sistemas operacionais nao suportados no momento.\n");

}

void finalizar(int erro){

if ( erro >= 5 ){
asm{

mov ah, 02h
int 90h
}
}

if (erro <= 4 ){
pxerrno+=(erro+1);
}
}

void limparerrorlevel(void){

errnoglobal=errnoglobal-pxerrno;
pxerrno=0;

}


#define __PXDOS_EPX__
#define __FELIPE_PXDOS__
#define __EPX__
#define __PXDOS_PXDOS_C__
#define __C_API_PXDOS_0.9.0__
#define __LIB_VER_1.0.6__
#define __ASM_SUPORTADO__
#define __EXECUTAVEL__
#define __EXECUTAVEL_PXDOS_EPX__ __EXECUTAVEL__ __EPX__
#ifndef __MODO__ 
#define __MODO__ "16-bit"
#endif
