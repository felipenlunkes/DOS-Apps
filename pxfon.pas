{
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
// Aplicativo para a troca de fonte de texto para PX-DOS®
//
// Copyright © 2012-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************
}

Program PXDOSFontes(Input,Output);
Uses DOS, CRT;

Var
  Armazenador: array[0..4095] of byte;
  Arquivo: file;
  Regs: Registers;
  Marcador, Marcador2, Marcador3: integer;
  NomeArquivo: string;
  Parametro, Parametro2, Parametro3: string;

function Existe(Nome: string): boolean;
Var
  Fonte: file;
begin
{$I-}
  Assign(Fonte, Nome);
  Reset(Fonte,1);
  Close(Fonte);
{$I+}
  Existe:=(IOResult=0) and (Nome<>'');
end;

begin

NomeArquivo := ParamStr(1);
Parametro := ParamStr(2);

  if (Parametro='/PX') then
  
  begin

marcador:=1; 
  
  end;
  
  if (Parametro2 = '/DEBUG') then
  begin
  
  marcador2:=1;
  
  end;
  
  if (Parametro = '/D') then
  begin
  
    if (marcador2 = 1) then 
	begin
	
	writeln;
	writeln('Removendo arquivo de fonte adicionado previamente...');
	writeln;
	
	end;
	
    with Regs do
    begin
      AH:=$11;
      AL:=$04;
      BH:=0;
      BL:=0;
      Intr($10, Regs);
    end;
	
    Halt(0);
	
  end;

  if not Existe(NomeArquivo) then
  begin
    
    writeln;	
    writeln('Arquivo de fonte ', NomeArquivo ,' nao encontrado');
    writeln;
	Halt(1);
	
  end;
  
  if (marcador2 = 1) then 
	begin
	
	writeln;
	writeln('Abrindo arquivo ', NomeArquivo, 'para a leitura...');
	writeln;
	
	end;
	
  Assign(Arquivo, NomeArquivo);
  Reset(Arquivo,1);
  BlockRead(Arquivo, Armazenador, 2048);
  Close(Arquivo);
  
  with Regs do
  begin
  
    AH:=$11;
    AL:=$10;
    BH:=16;
    BL:=0;
    CX:=127;
    DX:=0;
    BP:=Ofs(Armazenador);
    ES:=Seg(Armazenador);
    Intr($10, Regs);
	
  end;
  
  if (marcador = 1) then begin
  
  writeln;
  writeln('O arquivo de fonte ', NomeArquivo , ' foi adicionado.');
  writeln;
  
  end;
  
end.