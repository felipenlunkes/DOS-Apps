/*

Estatísticas para arquivos fonte em C da IDE do PX-DOS®

Este programa abre o arquivo fonte e retorna informações
relevantes ao seu tamanho, número de linhas de Código, número
de linhas usadas apenas para comentários e sem código e linhas
com código in-line.

Copyright © 2016 Felipe Miguel Nery Lunkes


*/


#include <stdio.h>
#include <string.h>
#include <ctype.h>

enum estados { EXE, DOC };
struct bandeiras { unsigned exe, doc; };
struct nLinhas { unsigned long todos, emBranco, exes, docs, naLinha; };

void exibir_status(const char *cabecalho, const struct nLinhas *status)
{
  printf("Estatisticas do arquivo '%s'\n", cabecalho);
  printf("%20s: %7lu\n", "Linhas no Total", status->todos);
  printf("%20s: %7lu\n", "Linhas em Branco", status->emBranco);
  printf("%20s: %7lu\n", "Linhas de Codigo", status->exes);
  printf("%20s: %7lu\n", "Linhas de Comentarios", status->docs);
  printf("%20s: %7lu\n", "Comentarios In-Line", status->naLinha);
  printf("%20s: %9.1lf\n", "% de codigo",
    (double)status->exes / status->todos * 100.0);
  printf("%20s: %9.1lf\n", "% de comentarios",
    (double)(status->docs + status->naLinha) / status->todos * 100.0);
}

void adicionar_a_total(struct nLinhas *total, const struct nLinhas *arquivo)
{
  total->todos += arquivo->todos;
  total->emBranco += arquivo->emBranco;
  total->exes += arquivo->exes;
  total->docs += arquivo->docs;
  total->naLinha += arquivo->naLinha;
}

void adicionar_a_contagem(struct nLinhas *status, const struct bandeiras *status)
{
  status->todos++;
  if (status->exe) {
    status->exes++;
    if (status->doc) status->naLinha++;
  }
  else if (status->doc)
    status->docs++;
  else status->emBranco++;
}

int passar(const char *texto, struct nLinhas *status)
{
  static enum estados estado = EXE;
  static int estanaString = 0;
  struct bandeiras status;

  for (memset(&status, 0, sizeof(status)); *texto; texto++)
    if (!isspace(*texto))
      if (estado == DOC) {
        status.doc++;
        if (*texto == '*' && *(texto + 1) == '/')
          texto++, estado = EXE;
      }
	  
      else { /* estado == EXE */
	  
        if (estanaString) {
          if (*texto == '\\')
            texto++;
          else if (*texto == '\"')
            estanaString = !estanaString;
        }
		
        else if (*texto == '/') {
		
          if (*(texto + 1) == '*') {
		  
            texto--, estado = DOC;
			
            continue;
			
          }
		  
          else if (*(texto + 1) == '/') {
		  
            status.doc++;
			
            break;
			
          }
		  
        }
		
        status.exe++;
		
      }
	  
  adicionar_a_contagem(status, &status);
  
  return (0);
}

int contar(const char *nome, struct nLinhas *total)
{
  struct nLinhas status;
  FILE *stream = fopen(nome, "r");
  char linha[256];

  if (!stream)
    return (printf("Erro abrindo '%s'\n", nome), 1);
	
  memset(&status, 0, sizeof(status));
  
  while (fgets(linha, sizeof(linha), stream))
    passar(linha, &status);
	
  if (!feof(stream))
    return (printf("Erro lendo '%s'\n", nome), 2);
	
  if (fclose(stream))
    return (printf("Erro fechando '%s'\n", nome), 3);
	
  adicionar_a_total(total, &status);
  
  exibir_status(nome, &status);
  
  return (0);
}

int arg_ok(int nargs, const char *prog)
{
  if (nargs > 1)
    return (1);
	
  puts("Contador de Linhas para fontes em C");
  printf("Uso: %s nome [nome...]\n", prog);
  puts("Em que nome e o arquivo a ser analisado.");
  
  return (0);
  
}

int main(int argc, char **argv)
{

  struct nLinhas total;

  if (!arg_ok(argc, *argv))
    return (1);
	
  memset(&total, 0, sizeof(total));
  
  while (*++argv)
    if (contar(*argv, &total))
      return (2);
	  
  printf("\n%d arquivo%cprocessado%c\n\n", argc - 1, argc > 2 ? 's' : ' ', argc > 2 ? 's' : ' ');
  
  exibir_status("Todos os arquivos", &total);
  
  return (0);
}
