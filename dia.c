//***********************************************************************
//       ______
//      /  __  \      Sistema Operacional PX-DOS®
//     /  |__|  \     Copyright © 2013-2016 Felipe Miguel Nery Lunkes
//    /  _____   \    Todos os direitos reservados.  
//   /   /    \   \     
//  /___/      \___\  Aplicativos do sistema
//
//
// Compatível com PX-DOS® 0.9.0 ou superior   
//
//***********************************************************************
//
//
// Aplicativo para a exibição de calendário do PX-DOS®
//
// Copyright © 2013-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************

#include <stdio.h>
#include <stdlib.h>

static int numero_dia(int yyyy, int mm, int x, int y);
static void prt3mon(int ano, int a, char *prtmon);

main(int argc, char **argv)
{
  int ano, ano_trabalho, dig1, dig2, dig3, dig4;

  if (argc < 2)
  {
  
    printf("\n\nCalendario para PX-DOS(R) 0.9.0\n");
    printf("\nVoce deve inserir um ano com 4 digitos.\n\n");
	
    return (1);
	
  }
  
  ano = atoi(*(argv+1));
  ano_trabalho = ano;
  dig1 = ano_trabalho/1000;  ano_trabalho%=1000;
  dig2 = ano_trabalho/100;  ano_trabalho%=100;
  dig3 = ano_trabalho/10;  ano_trabalho%=10;
  dig4 = ano_trabalho;
  
  printf("\n                                %d %d %d %d\n\n\n\n\n",
      dig1,dig2,dig3,dig4);
	  
  prt3mon(ano, 0, "       JANEIRO                 FEVEREIRO"
      "                   MARCO");
	  
  prt3mon(ano, 1, "        ABRIL                     MAIO"
      "                     JUNHO");
	  
  prt3mon(ano, 2, "        JULHO                    AGOSTO"
      "                  SETEMBRO");
	  
  prt3mon(ano, 3, "       OUTUBRO                 NOVEMBRO"
      "                 DEZEMBRO");
	  
  return (0);
  
}

static void prt3mon(int ano, int a, char *prtmon)
{
  static char *letras = " s  t  q  q  s  s  d     "
                         " s  t  q  q  s  s  d     "
                         " s  t  q  q  s  s  d\n";
  int b, i, j, x;

  printf("%s\n\n",prtmon);
  printf("%s",letras);
  for (i=0;i<6;i++)
  {
  
    for (b=1;b<=3;b++)
    {
	
      for (j=0;j<7;j++)
      {
	  
        x = numero_dia(ano,a*3+b,i,j);
        if (x) printf("%2d ",x);
		
        else printf("   ");
		
      }
	  
      printf("    ");
	  
    }
	
    printf("\n");
	
  }
  
  printf("\n\n\n\n");
  
  return;
  
}

#define ebissexto(ano) ((((ano%4)==0) && ((ano%100)!=0)) || \
    ((ano%400)==0))

#define dow(y,m,d) \
  ((((((m)+9)%12+1) * 26 - 2)/10 + (d) + \
  ((y)%400+400) + ((y)%400+400)/4 - ((y)%400+400)/100 + \
  (((m) <= 2) ? ( \
  (((((y)%4)==0) && (((y)%100)!=0)) || (((y)%400)==0)) \
  ? 5 : 6) : 0)) % 7)

static int numero_dia(int yyyy, int mm, int x, int y)
{
  static int tabela_dias[] = { 31, 28, 31, 30, 31, 30,
                          31, 31, 30, 31, 30, 31};
  int a, b, c;

  a = dow(yyyy,mm,1);
  b = x * 7 + y;
  c = tabela_dias[mm-1];
  
  if ((mm == 2) && ebissexto(yyyy)) c++;
  
  if (b < a) return (0);
  
  if ((b-a) >= c) return (0);
  
  return ((b-a+1));
  
}

