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
// Aplicativo para a exibição de tipo de arquivo para PX-DOS®
//
// Copyright © 2012-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>


char *tipoArquivo(char *nomearquivo)
    {
    static struct
        {
        char *tipo;
        char *assinatura;
        int  offset;
        } opcoes[] =
            {
			
			"Arquivo compactado ZIP",   "PK",       0,
			"Executavel APPX(R)",  "APPX", 0,
			"Executavel MZ", "MZ", 0,
			"Registro Mestre do PX-DOS(R)", "PXREG", 0,
			"Driver para PX-DOS(R)", "PX", 0,
			"Biblioteca de Execucao PX-DOS(R)", "PXLIB", 0
			
			};

    #define NUM_ARC (sizeof(opcoes) / sizeof(opcoes[0]))

    int  i;
    char hdr[256];
    char *retornar_tipo = NULL;
    ARQUIVO *arquivoASerAberto;

    assert ((arquivoASerAberto = fopen(nomearquivo, "rb")) != NULL);
	
    fread(hdr, sizeof(hdr), 1, arquivoASerAberto);
	
    fclose(arquivoASerAberto);
	
    for (i = 0; i < NUM_ARC; i++)
        {
		
        if (memcmp(hdr + opcoes[i].offset, opcoes[i].assinatura, strlen(opcoes[i].assinatura)) == 0)
            {
            retornar_tipo = opcoes[i].tipo;
			
            break;
			
            }
        }
		
    return(retornar_tipo);
	
    }


int main(int argc, char **argv)
    {
	
    char *t;
    int  i;

    if (argc == 1)
        {
		
        printf("Uso: Tipo arquivo.extensao\n");
        exit(EXIT_FAILURE);
		
        }

    if ((t = tipoArquivo(argv[1])) == NULL)
        printf("Tipo de arquivo desconhecido pelo sistema.\n");
    else
        printf("\nO arquivo '%s' e um %s.\n", argv[1], t);
		
    return(EXIT_SUCCESS);
	
    }
