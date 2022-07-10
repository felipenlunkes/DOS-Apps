/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*   #$$%%@!#$%                                                      */
/*   !!@#!$!$!$         Sistema Operacional PX-DOS ®                 */
/*   !@@#   #$%                                                      */
/*   #$$%   &*$                                                      */
/*   $#%@   @#&                                                      */
/*   #%$&*(@*@&                                                      */
/*   @#$@$#@$%$     © 2013-2016 Felipe Miguel Nery Lunkes            */
/*   $%&*                Todos os direitos reservados                */
/*   @#&*                                                            */
/*   @&*%                                                            */
/*   #&*@                                                            */
/*                                                                   */
/*                                                                   */
/* O PX-DOS ® é marca registrada de Felipe Miguel Nery Lunkes no     */
/* Brasil. © 2013-2014 Felipe Miguel Nery Lunkes. Todos os direitos  */
/* reservados. A reprodução total ou parcial, de quaisquer trechos   */
/* do código aqui presente é expressamente probida, sendo passível   */
/* de punição legal severa.                                          */
/*                                                                   */
/* Copyright © 2013-2014 Felipe Miguel Nery Lunkes                   */
/* Todos os direitos reservados.                                     */
/*                                                                   */
/*********************************************************************/ 

#include <stdio.h>
#include <pxdos.h>
#include <string.h>
#include <ctype.h>
#include <time.h>


void Abrir_Registro(char *nome);

void pausar(void);

void processararquivo(void);

void titulo(int mensagem1, int mensagem2);

tamanho_t tamanho;

ARQUIVO *registro;
 
int sistema;
 
int subchaverequerida=0;

char *componentes[63];
char *drivers[63];
char *dispositivos[64];
char *usuarios[10];
char *perfis[11];
char *info[10];
char *autoridade[10];
char *previlegio[2];
char *previlegio_perfil[11];
int lista[10];
int contador_lista;

int contador_subsis=0;
int contador_dispositivo=0;
int contador_driver=0;
int contador_perfil=0;
int contador;
int x;

int x;  
 
char driver[600] = "";

char msg[600] = "";
 
char buf[200];

char usuario[200]="";

char perfil[40]="";

char dispositivo[200];

char *controle[50];

char componente[600]="";
		
char resp;
 
char *perfil_nome[10];
 
int contador_perfil_mestre=0;
 
 static unsigned char cmdt[140];

 
 static struct {

    int ambiente;
	
    unsigned char *fimcmd;
	
    char *parametro1;
	
    char *parametro2;
	
} blocodeParametros = { 0, cmdt, NULL, NULL };

char *mensagens[]={
"Perfis registrados no sistema:",
"------------------------------",
"Usuarios registrados no sistema:",
"--------------------------------",
"Dispositivos configurados para o sistema:",
"-----------------------------------------",
"Componentes adicionados ao registro:",
"------------------------------------"

};

 int main(int argc, char *argv[])
 {

 
 componentes[0]=argv[0];
 
                perfis[0]="Autoridade PX-DOS";
				perfis[1]="Sistema PX-DOS";
				perfis[2]="Administrador";
				previlegio_perfil[0]="Sistema";
				previlegio_perfil[1]="Sistema";
				previlegio_perfil[2]="Administrador";
				
 Abrir_Registro(argv[1]);
 
 }
 
 
void Abrir_Registro(char *nome)
{
   
    registro = abrir(nome, "r");
	
	if (registro == NULL) 
	{
	
printf("\nArquivo de registro '%s' nao encontrado!\n", registro);

	asm{
	
	mov ah, 02h
	int 90h
	
	}
	
	}
	
    if (registro != NULL)
    {   

			
        while (fgets(buf, sizeof buf, registro) != NULL)
        {
		
            processararquivo();
			
        }
		
        fechar(registro);
    }
	
    return;
	
}

static int compararString(char *um, char *dois)
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

 void processararquivo(void)
{
    char *p;

    tamanho = tamanhostring(buf);
    if ((tamanho > 0) && (buf[tamanho - 1] == '\n'))
    {
	
        tamanho--;
        buf[tamanho] = '\0';
		
    }
	
    p = strchr(buf, ' ');
	
    if (p != NULL)
    {
	
        *p++ = '\0';
		
    }
	
    else
    {
	
        p = buf + tamanho;
		
    }
	
    tamanho -= (tamanho_t)(p - buf);
		
/*


	// Área de processamento do arquivo




*/
		
// Mais uma opção de comando
			
		if (memcmp(buf, "DISPOSITIVO=", 12) == 0){

	
	                memcpy(dispositivo, buf + 12, sizeof dispositivo);
                    dispositivo[sizeof dispositivo - 1] = '\0';
                    p = strchr(dispositivo, '\r');
			
			    printf("\nDispositivo '%s' adicionado ao registro.\n", dispositivo);
				
				contador_dispositivo+=1;
				
				dispositivos[contador_dispositivo]=dispositivo;
				
				subchaverequerida=1;
				
				  if (p != NULL)
                    {
                       
					   *p = '\0';
					   
                    }
					
	
	}
	
// Mais uma opção de comando

else if (memcmp(buf, "USUARIO=", 8) == 0){

	
	                memcpy(usuario, buf + 8, sizeof usuario);
                    usuario[sizeof usuario - 1] = '\0';
                    p = strchr(usuario, '\r');
			
			    printf("\nUsuario '%s' registrado.\n", usuario);
				
				
				usuarios[0]="Sistema";
				usuarios[1]=usuario;
				previlegio[0]="Sistema";
				previlegio[1]="Normal";
				
				subchaverequerida=1;
				
				  if (p != NULL)
                    {
                       
					   *p = '\0';
					   
                    }
					
	
	}

	else if (memcmp(buf, "PERFIL=", 7) == 0){
	
	 contador_perfil_mestre+=1;
	 
 

	                memcpy(perfil, buf + 7, sizeof perfil);
                    perfil[sizeof perfil - 1] = '\0';
                    p = strchr(perfil, '\r');
			
			    perfil_nome[contador_perfil_mestre]=perfil;
			
			    printf("\nPerfil de usuario '%s' registrado.\n", perfil);
				
				
				for (x=3; x<=10; x++){
				
				if (perfis[x] == NULL){
				
				
				perfis[x]=perfil_nome[contador_perfil_mestre];
				
				previlegio_perfil[x]="Normal";
				x=11;
				
				}
				
				}
				
			
				
				  if (p != NULL)
                    {
                       
					   *p = '\0';
					   
                    }
					
	
	}
	
	else if (memcmp(buf, "[PAUSA]", 7) == 0){
	
	printf("\nLeitura do registro pausada para conferencia.\n");
	printf("\nPressione qualquer tecla para continuar...\n");
	
	pausar();
	
	}

	else if (memcmp(buf, "VERPERFIS", 9) == 0){
			
			cls();
			
			titulo(0,1);
			
			for (contador=0; contador <=10; contador++){
			
			
			printf("\nPerfil numero %d: %s - Privilegio: %s", contador, perfis[contador], previlegio_perfil[contador]);
			
			if (contador == 10){
			
			printf("\n\nPressione qualquer tecla para continuar...\n");
			
			pausar();
			
			
			}
			}
			
			}

	
// Mais uma opção de comando

	else if (memcmp(buf, "VERUSUARIOS", 11) == 0){
	
	cls();
	
	titulo(2,3);
	
	
	printf("\n\nUsuario: %s - Privilegio: %s", usuarios[0], previlegio[0]);
	printf("\n\nUsuario: %s - Privilegio: %s", usuarios[1], previlegio[1]);
	
	printf("\n\nPressione qualquer tecla para continuar...\n\n");
	
	pausar();
	
	printf("\n\n");
	
	}
	
	
// Mais uma opção de comando
			
	else if (memcmp(buf, "VERDISPOSITIVOS", 15) == 0){
			
	cls();
			
	titulo(4,5);
			
	    for (contador=1; contador <=63; contador++){
			
	    if (contador == 15 | contador == 30 | contador == 45 | contador == 60){
			
	printf("\n\nPressione qualquer tecla para continuar...\n");
			
	pausar();
	
	cls();
	
	titulo(4,5);
			
	}
			
	printf("\n%s - %d", dispositivos[contador], contador);
			
		if (contador == 63){
			
		printf("\n\nPressione qualquer tecla para continuar...\n");
			
		pausar();
			
			
		}
		
	}
			
	}

	// Mais uma opção de comando
			
			
// Mais uma opção de comando
			
	else if (memcmp(buf, "REM", 3) == 0){			
			
	// Comentário não processado
			
	}
			
// Mais uma opção de comando
			
	else if (memcmp(buf, "'", 1) == 0){			
			
	// Comentário não processado
			
	}
			
// Fim
			
	
	
}

void pausar(void){

asm {
			
			mov ah, 00h
			int 16h
			
			}

}

void titulo(int mensagem1, int mensagem2)
{

    printf("%s\n", mensagens[mensagem1]);
	printf("%s\n\n", mensagens[mensagem2]);

}
	
char *copyright[]={

"Copyright (C) 2016 Felipe Miguel Nery Lunkes",
"Todos os direitos reservados."

};




	