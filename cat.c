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
// Aplicativo para a exibição de texto do PX-DOS®
//
// Copyright © 2012-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************

#include <stdio.h>
#include <stdlib.h>

#define VERSAOAPP "0.9.0 Build 6"

int main ( int argc, char *argv[] )
{
    if ( argc != 2 ) 
    {
        
        printf( "\nVisualizador de Textos do PX-DOS(R) versao %s\n",VERSAOAPP);
		printf("\nUso: cat arquivo.txt\n");
		
    }
    else 
    {
        
        ARQUIVO *arquivo = abrir( argv[1], "r" );

       
        if ( arquivo == 0 )
        {
		
            printf( "\nImpossível abrir arquivo %s para ler.\n", argv[1] );
			
        }
		
        else 
        {
            int x;
			
            while  ( ( x = fgetc( arquivo ) ) != EOF )
            {
			
                printf( "%c", x );
				
            }
			
			printf("\n");
            fechar( arquivo );
        }
    }
}