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
// Aplicativo para a exibição de conteúdo compilado do PX-DOS®
//
// Copyright © 2013-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Compatível apenas com a biblioteca Borland

static void exibir(ARQUIVO * fp, long inicio, long contador);
static void pular(ARQUIVO * fp, long inicio);

int main(int argc, char **argv)
{
    ARQUIVO *fp;
    long inicio, contador;

    if (argc < 2)
    {
        puts("Uso: HEX arquivo inicio [tamanho]");
        return (1);
    }
    if (argc > 2)
    {
        inicio = strtol(*(argv + 2), NULL, 0);
    }
    else
    {
        inicio = 0L;
    }
    if (argc > 3)
    {
        contador = strtol(*(argv + 3), NULL, 0);
    }
    else
    {
        contador = -1L;
    }
    fp = fopen(*(argv + 1), "rb");
    if (fp == NULL)
    {
        printf("Impossivel abrir o arquivo %s para leitura.\n", *(argv + 1));
        return (1);
    }
    pular(fp, inicio);
    exibir(fp, inicio, contador);
    return (0);
}

static void exibir(ARQUIVO * fp, long inicio, long contador)
{
    int c, pos1, pos2;
    long x = 0L;
    char prtln[100];

    while (((c = fgetc(fp)) != EOF) && (x != contador))
    {
        if (x % 16 == 0)
        {
            memset(prtln, ' ', sizeof prtln);
            sprintf(prtln, "%0.6lX   ", inicio + x);
            pos1 = 8;
            pos2 = 45;
        }
        sprintf(prtln + pos1, "%0.2X", c);
        if (isprint(c))
        {
            sprintf(prtln + pos2, "%c", c);
        }
        else
        {
            sprintf(prtln + pos2, ".");
        }
        pos1 += 2;
        *(prtln + pos1) = ' ';
        pos2++;
        if (x % 4 == 3)
        {
            *(prtln + pos1++) = ' ';
        }
        if (x % 16 == 15)
        {
            printf("%s\n", prtln);
        }
        x++;
    }
    if (x % 16 != 0)
    {
        printf("%s\n", prtln);
    }
    return;
}

static void pular(ARQUIVO * fp, long inicio)
{
    long x = 0;

    while (x < inicio)
    {
        fgetc(fp);
        x++;
    }
    return;
}
