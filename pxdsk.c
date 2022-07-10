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
// Geometria de disco para PX-DOS®
//
// Copyright © 2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************

#include <stdlib.h> /* atoi() */
#include <stdio.h>  /* printf(), sscanf() */
#include <bios.h>   /* _DISK_nnn, _disco_BIOS() */

/* CPU x86 */

#define	LE16(X)	*(uint16_t *)(X)
#define	LE32(X)	*(uint32_t *)(X)


typedef unsigned short	uint16_t;
typedef unsigned long	uint32_t;

//***********************************************************************

#define _RESETAR_DISCO     0
#define _LER_DISCO      2

struct disco_t
{
	unsigned drive, cabeca, trilha, setor, nsetor;
	void far *buffer;
};

int _disco_BIOS(int cmd, struct disco_t *i)
{
	return biosdisk(cmd, i->drive, i->cabeca, i->trilha, i->setor,
		i->nsetor, (void *)i->buffer);
}



//***********************************************************************

static int ler_setor(unsigned drive, unsigned cil, unsigned cabeca,
		unsigned sec, unsigned char *buf)
{
	struct disco_t cmd;
	unsigned tentativas, erro;

	cmd.drive = drive;
	cmd.cabeca = cabeca;
	cmd.trilha = cil;
	cmd.setor = sec;
	cmd.nsetor = 1;
	cmd.buffer = buf;
	
	for(tentativas = 3; tentativas != 0; tentativas--)
	{
	
		erro = _disco_BIOS(_LER_DISCO, &cmd);
		erro >>= 8;
		
		if(erro == 0)
		{
		
		return 0;
		
		}
		
		_disco_BIOS(_RESETAR_DISCO, &cmd);
	}
	
	printf("\nErro 0x%02X lendo drive\n", erro);
	
	return -1;
	
}

//***********************************************************************

static int lg2(unsigned arg)
{
	unsigned log;

	for(log = 0; log < 16; log++)
	{
	
		if(arg & 1)
		{
		
			arg >>= 1;
			
			return (arg != 0) ? -1 : log;
			
		}
		
		arg >>= 1;
		
	}
	
	return -1;
	
}

//***********************************************************************

static int checar_setor_inicializacao(unsigned char *buf)
{
	unsigned temp;
	int ruim = 0;

	if(buf[0] == 0xE9)
	{
	
		// Ok
		
	}		
	else if(buf[0] == 0xEB && buf[2] == 0x90)
	{	
	
		// Ok
		
	}
	
	else
	{
	
		printf("\nJMP/NOP faltando! Nao deve ser setor PX-DOS(R)!\n");
		
		ruim = 1;
		
	}

	// Checar algumas outras coisas
	
	temp = buf[13];
	
	if(lg2(temp) < 0)
	{
	
		printf("\nSetores por cluster: (%u) nao e multiplo de 2\n",
			temp);
			
		ruim = 1;
		
	}
	
	temp = buf[16];
	
    // Existem alguns discos que apresentam apenas uma cópia da FAT, o que
	// também é válido.

	if(temp != 1 && temp != 2)
	{
	
		printf("\nNumero invalido de FATs (%u)\n", temp);
		
		ruim = 1;
		
	}
	temp = LE16(buf + 24);

	if(temp == 0 || temp > 63)
	{
	
		printf("\nNumero invalido de setores (%u)\n", temp);
		
		ruim = 1;
		
	}
	
	temp = LE16(buf + 26);
	

	
	if(temp == 0 || temp > 255)
	{
	
		printf("\nNumero invalido de cabecas de leitura (%u)\n", temp);
		
		ruim = 1;
		
	}
	
	return ruim;
}

//***********************************************************************

int main(int arg_c, char *arg_v[])
{
	unsigned num_fats, spc, bps, nre, fs, bs, rs, fatorbps;
    float totalmb;
	unsigned drive, part = 0;
	unsigned char buf[512];
	unsigned long ts, ds;

	printf("\nDiagnostico de disco do PX-DOS(R) - PXDSK");
	printf("\nCopyright (C) 2016 Felipe Miguel Nery Lunkes");
	printf("\nTodos os direitos reservados.");
	
	if(arg_c < 2){
	
		printf("\n\nUtilize este programa para identificar a geometria do disco utilizado.\n\n");
		
		printf("Este programa necessita de parametros:\n\n");
		
		printf("PXDSK DISCO PARTICAO, em que:\n\n");
		printf("> DISCO = 0 (0x00), 1 (0x01), 80 (0x80) ou 81 (0x81).\n");
		printf("> PARTICAO = 1 a 4 (em caso de disco rigido - HD).\n\n");
		
		exit(1);
	
}
	
	else
	{
	
		sscanf(arg_v[1], "%X", &drive);
		
		
		if(drive != 0 && drive != 1 && drive != 0x80 && drive != 0x81)
		{
		
			printf("\nNumero de drive incorreto em INT 13H 0x%X "
				"(deve ser 0, 1, 0x80, ou 0x81)\n", drive);
				
			return 1;
			
		}
		
		if(arg_c < 3) {
			
			part = 0;
			
			}
			
		else
		{
		
			part = atoi(arg_v[2]);
			
			if(part > 3)
			{
			
				printf("\nNumero invalido de particao %u "
					"(deve ser < 4)\n", part);
				return 1;
			}
			
		}
		
	}
	
	if (drive >= 0x80){
	
	printf("\n\nParticao %u no ", part);
	printf("drive 0x%02X:\n", drive);
	
	}
	
	if (drive == 0x00){
	
	printf("\n\nDisco A: (Disquete)\n");
	
	}
	
	if (drive == 0x01){
	
	printf("\n\nDisco B: (Disquete)\n");
	
	}
	
	// Ler setor de inicialização no disquete e MBR/tabela de partição
	// no disco rígido
	

	if(ler_setor(drive, 0, 0, 1, buf) != 0)
	{
	
		return 1;
	
	}
	
	if(drive >= 0x80)
	{
		unsigned char *tabela_particao, cabeca, sec;
		unsigned short cil;

    // Ponteiro para a entrada da tabela de partições
	
		tabela_particao = buf + 446 + 16 * part;
		
    // Ter certeza que se trata de FAT 16
	
		if(tabela_particao[4] != 6)
		{
		
			//goto NAO;
			
		}
		
    // Iniciando no CHS da partição
	
		cil = tabela_particao[3];
		cabeca = tabela_particao[1];
		sec = tabela_particao[2] & 0x3F;
		
		if(tabela_particao[2] & 0x40)
		{
		
			cil |= 0x100;
		}
		
		if(tabela_particao[2] & 0x80)
		{
		
			cil |= 0x200;
		
		}
		
    // Ler o primeiro setor do disco (setor de inicialização no HD)
	
		if(ler_setor(drive, cil, cabeca, sec, buf) != 0)
		{
			return 1;
			
		}
	
	}
	
	if(checar_setor_inicializacao(buf))
NAO:	{

		printf("\nEste nao e um volume FAT.\n");
		return 1;
		
	}
	
	bps = LE16(buf + 11);
	
	printf("\nGeometria do disco:\n\n");
	printf("> Bytes por setor = %u\n", bps);
	printf("> Numero de cabecas = %u\n", LE16(buf + 26));
	printf("> Setores por trilha = %u\n", LE16(buf + 24));

	spc = buf[13];
	
	printf("\nInformacoes da FAT:\n\n");
	
	printf("> Setores por cluster = %u\n", spc);
	
	num_fats = buf[16];
	
	printf("> Numero de tabelas de alocacao (FATs) = %u\n", num_fats);
	
	nre = LE16(buf + 17);
	
	printf("> Numero de entradas de diretorio raiz = %u\n", nre);
	
	fs = LE16(buf + 22);
	
	printf("> Setores por FAT = %u\n", fs);
	
	fs *= num_fats;
	
	printf("> Numero de setores reservados = %lu (inicio da particao)\n",
		LE32(buf + 28));

	ts = LE16(buf + 19);
	
	if(ts == 0)
	{
	
		ts = LE32(buf + 32);
		
	}
	
	bs = LE16(buf + 14);
	rs = (nre * 32 + bps - 1) / bps;

	ds = ts - bs - rs - fs;
	
	while(ds % spc != 0)
	{
	
		ds--;
    
	}
	
	printf("> Total de clusters = %lu ", ds / spc);
	
	if(ds / spc < 4085)
	
	{
	
	    printf("(Sistema de Arquivos FAT12)\n");
	
	}
	
	else if(ds / spc < 65525u)
	{
	
		printf("(Sistema de Arquivos FAT16)\n");
	
	}
	
	else
		printf("(Sistema de Arquivos FAT32)\n");
		
	printf("> Setores: %u boot, %u root, %u FAT, %lu dados, %lu perdidos, "
		"%lu total\n",
		bs,			// reservado/setor de inicialização
		rs,			// setores do diretório raiz
		fs,			// setores da FAT
		ds,			// setores de dados
		ts - bs - rs - fs - ds,	// setores perdidos/ruins
		ts);			// total de setores
		
	if (bps == 512){

    fatorbps=2;
    
    }
	
    totalmb=ts/fatorbps; // Contando megabytes aqui...
	
	totalmb=totalmb/1024;
	
	if (drive == 0x00){
	
	printf("> Espaco total do drive A: %f megabytes.\n\n", totalmb);
	
	
	}
	
	if (drive == 0x01){
	
	printf("> Espaco total do drive B: %f megabytes.\n\n", totalmb);
	
		
	}
	
	if (drive == 0x80){
	
	printf("> Espaco total do drive C: %f megabytes.\n\n", totalmb);
	
		
	}
	
	if (drive == 0x81){
	
	printf("> Espaco total do drive D: %f megabytes.\n\n", totalmb);
	
		
	}
	
	exit(0);
	
}

//***********************************************************************