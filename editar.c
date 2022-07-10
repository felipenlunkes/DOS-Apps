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
// Aplicativo para a modificação de texto do PX-DOS®
//
// Copyright © 2013-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************

#include <stdio.h>
#include <stdlib.h>


int main ( int argc, char *argv[] )
{
    if ( argc != 2 ) 
    {
        
        printf( "\nEditor de Textos do PX-DOS(R)\n");
		printf("\nUso: editar arquivo\n");
    }
    else 
    {
        
      
   ARQUIVO *arquivo = abrir( argv[1], "rw" );
   char string[100];
   int i;
   
   if(!arquivo)
    {
	
      printf( "Erro na abertura do arquivo.");
	  
      sair(0);
	  
    }
	
   printf("Entre com o texto a ser adicionado no arquivo:");
   gets(string);
   
   for(i=0; string[i]; i++) fputc(string[i], arquivo); /* Grava a string, caractere a caractere */
   
   fechar(arquivo);
  
   return 0;

    }
}