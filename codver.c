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

// Coloca a versão do Kernel compatível com o MS-DOS

#include <stdio.h>
#include <stdlib.h>

unsigned int getversion(void);

int main(int argc, char **argv)
{
    ARQUIVO *fu;
    unsigned int version;
    
    if (argc < 2)
    {
	
        printf("Uso: CODVER <arquivo>\n");
		
        return (EXIT_FAILURE);
		
    }
	
    fu = abrir(*(argv + 1), "rb+");
	
    if (fu == NULL)
    {
	
        printf("Impossivel abrir arquivo de Kernel %s\n", *(argv + 1));
        return (EXIT_FAILURE);
		
    }
	
    version = getversion();
	
	printf("Versao do Kernel PX-DOS: %d", version);
    fseek(fu, 3, SEEK_SET);
    fputc(version >> 8, fu);
    fputc(version & 0xff, fu);
    fechar(fu);
	
    return (0);
	
}

#include <dos.h>

unsigned int getversion(void)
{
    union REGS registradoresin;
    union REGS registradoresout;
    
    registradoresin.h.ah = 0x01;
	registradoresin.x.bx= 0x03;
    int86(0x90, &registradoresin, &registradoresout);
    return (((unsigned int)registradoresout.h.al << 8) | registradoresout.h.ah);
}
