/*

Biblioteca para Criação de Aplicativos para PX-DOS® 0.9.0

Versão desta biblioteca: 1.0.Beta6

Use versaolib() ou libver() para retornar a versão corrente.

Copyright (C) 2013 Felipe Miguel Nery Lunkes

Todos os direitos reservados.

Não é permitida a cópia indevida sem a autorização por escrito do devido
desenvolvedor desta biblioteca de Funções C.

*/

// Métodos presentes nas bibliotecas de função C do PX-DOS


char libver(void);           // Retorna a versão da biblioteca
void contarnatela(int inicial, int final); // Conta na tela o valor de X
void morrer(int imprimir);   // Finaliza o aplicativo e retorna erro ao PX-DOS com  
                             // COD. de Erro
char readln(void);           // Função usada para obter dados diretamente do teclado
                             // Perigoso! Não utiliza funções do Sistema 
							 // Operacional 
							 // PX-DOS®
void writeln(char imprimir); // Função usada para imprimir valores de Variáveis 
                             // direto na tela. Perigoso! Não utiliza funções do
							 // Sistema Operacional PX-DOS®
long pot(int a, int b);      // Realiza a potência de a por b (a^b)
int par(int numero);         // Verifica se um número é par e retorna 0 para par e
                             // 1 para ímpar
void linha(void);            // Salta uma linha
void linhas(int numero);     // Salta um número determinado de linhas
int cls(void);               // Limpa a tela através de funções Assembly 
                             // independentes *Funcional!*
int contar(int inicial, int final); // Conta o intervalo entre dois números
int soma(int a, int b);      // Soma dois valores inteiros  
int subtracaoa(int a, int b); // Subtrai a por b (a-b)
int subtracaob(int a, int b); // Subtrai b por a (b-a)
long mult(long a, long b);   // Multiplica a por b em padrão longo (a*b)
void autor(void);            // Exibe o autor da biblioteca
void versaolib(void);        // Exibe a versão da biblioteca
extern __escrever;           // Função externa para escrever direto na tela
#define DOSPREF
void DOSPREF clrscr(void);   // Função em Assembly para cls (Alternativo) Perigoso!
extern __desligarsom;        // Função em Assembly para emitir som. Perigoso!
extern __emitirsom;          // Função em Assembly para emitir som. Perigoso!
asm { extrn __clrscr }
void sair(int erro);         // Função que finaliza o aplicativo. Use erro 5 ou 6
                             // para fechar o aplicativo. Códigos de erro menores
							 // serão tratados.
int errorlevel(void);        // Função para visualizar o nível dos contadores
                             // de erros tratados pelo sistema. Exibe a quantidade 
							 // de erros relatados no código.
void limparerrorlevel(void); // Função para limpar o nível dos contadores de erro							
void pausa(char mensagem);   // Função que pausa a execução do programa...
int compararString(char *um, char *dois); // Compara duas Strings e retorna 0 para igual
                                          // e 1 para diferente.
void reiniciar(int metodo); // Reinicia o computador de acordo com o parametro recebido.
                            // 1 para partida a frio e 0 para reinicialização simples.
							
// Variáveis exteriores - Presentes nas bibliotecas

extern char compilacao[256];
extern int versao_lib;
extern long versao_completo;
extern char *suporte;
extern int errno;
extern int errnoglobal;
extern unsigned int *vidmem;
extern int *mem; 
unsigned int *cs;

// Fim dos métodos presentes nas bibliotecas de função C do PX-DOS® e variáveis
// externas.

// Apelidos para as variáveis. Isto permite a migração de programas Java para C
// 16 Bits, facilitando a portabilidade e pouca alteração de código.

typedef char string; // Apelido para tipo char
typedef unsigned int intna; // Apelido para chave inteira não assinada
typedef int integer; // Apelido para variável inteira 
typedef char String; // Apelido Java para variável tipo char

// int, char, long e boolean ainda podem ser usadas da mesma forma.

typedef struct {

char nomeapp;
char autor;
integer versao;
} appver; // Não altere esta struct!

typedef struct {

intna x;
intna y;
intna modo_video;
string nome;
string modo;
intna cor;

} video ; // Não altere esta struct!

video *VD;
appver *DADOS;


#define _PXDOS_ // Não remova este macro. Caso isto ocorra, podem ocorrer erros 
                // durante a compilação e linkagem do aplicativo. O padrão do 
				// compilador Turbo C é _MSDOS_. Isso pode causar erros nas 
				// bibliotecas criadas especificamente para o PX-DOS. Para
				// corrigir este problema, o macro _PXDOS_ deve estar definido.
				// As bibliotecas PX-DOS® só podem ser usadas para gerar um 
				// aplicativo PX-DOS®. Sendo assim, elas não podem ser usadas
				// para gerar aplicativos ou código para outro sistema operacional,
				// pois os aplicativos podem ser incompatíveis em diversos aspectos.
				// Para isso, a chave _PXDOS_ é usada. Quando usada, a parte da 
				// biblioteca especifica para o PX-DOS será usada. O PX-DOS é 
				// incompatível com muitas bibliotecas de outros sistemas 
				// operacionais. Isso diz ao compilador para usar código PX-DOS®
				// específico.

#ifdef _PXDOS_
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#endif

#ifndef _PXDOS_
printf("Impossivel compilar para outro Sistema Operacional");
printf("\n\nDiversos erros poderao ocorrer na compilacao ou linkagem do aplicativo.");
printf("\n\nObrigado, Felipe Miguel Nery Lunkes.\n");
exit();

#endif

// Estes são símbolos presentes nas bibliotecas C do PX-DOS específicos para ele.
// Não altere-os ou os remova. Isto pode causar instabilidades ao executar alguns
// aplicativos pelo sistema operacional PX-DOS. Também pode culminar em erros 
// durante o processo de compilação do aplicativo. Esses símbolos são ligados
// com as bibliotecas e fornecem um ponto de compatibilidade com o sistema.

#ifndef __PXDOS_INCLUDED__
#define __PXDOS_INCLUDED__
#endif

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

// Fim dos símbolos específicos do sistema.