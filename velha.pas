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
// Jogo da Velha para PX-DOS®
//
// Copyright © 2012-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************
}

program velha;

uses crt, dos;

var XO: array[1..9] of Char;
    Ch: Char;
    MC: 1..2;
    AD: Boolean;
    var EVXO: record
		  VX, VO, E: Integer;
		  end;
const versaoapp = '1.5.42';
procedure move; forward;
procedure Placar(VXOE: Integer); forward;
procedure BackGround; forward;
procedure Menu; forward;
procedure VERSAO; forward;

function AI: Integer;
var I, S: Integer;
begin
AD:=False;
S:=0;
for I:=1 to 9 do
if not (XO[I] = #0) then
S:=S+1;
if not (S = 9) then
repeat
I:=random(10);
if not (I = 0) then
if not ((XO[I] = 'X') or (XO[I] = 'O')) then begin
AI:=I;
AD:=True;
end;
Until AD = True;
end;

procedure Linhas;
var I: Integer;
begin
TextColor(14);
for I:=3 to 22 do begin
gotoxy(35,I); write(#219);
gotoxy(42,I); write(#219);
end;
for I:=29 to 48 do begin
gotoxy(I,9); write(#219);
gotoxy(I,16); write(#219);
end;
end;

procedure ponto(N:Integer; SXO: Integer);
const p: record
	    X,Y: array[1..3,1..2] of integer;
	    end = (X:((31,32),(38,39),(45,46));
	    Y:((5,6),(12,13),(19,20)));
const coord: array[1..9,1..2] of Integer = ((1,1),(2,1),(3,1),(1,2),(2,2),(3,2),(1,3),(2,3),(3,3));
const XOS: array[0..3,1..2,1..2] of Char=((('\','/'),('/','\')),((#219,#219),(#219,#219)),(('/','\'),('\','/')),
((' ',' '),(' ',' ')));
var I:array[1..2] of Integer;
begin
TextColor(2);
for I[1]:= 1 to 2 do
for I[2]:= 1 to 2 do begin
gotoxy(p.X[coord[N,1],I[2]],p.Y[coord[N,2],I[1]]); write(XOS[SXO,I[1],I[2]]);
end;
end;

procedure Init;
begin
EVXO.VX:=0;
EVXO.VO:=0;
EVXO.E:=0;
Ch:='Q';
BackGround;
Menu;
end;

procedure JogoNovo;
var I: Integer;
begin
Writeln;
Writeln('Carregando...');
Delay(2000);
ClrScr;
for I:=1 to 9 do
XO[I]:=#0;
Linhas;
for I:=1 to 9 do
ponto(I,3);
Placar(0);
ponto(1,1);
end;

procedure Verificar;
const V: array[1..8] of record
				N: array[1..3] of Integer;
				end = ((N:(1,2,3)),(N:(4,5,6)),(N:(7,8,9)),(N:(1,4,7)),(N:(2,5,8)),
				(N:(3,6,9)),(N:(1,5,9)),(N:(3,5,7)));
const OX: array[1..2] of Char = ('X','O');
var I:array[1..2] of Integer;
begin
TextColor(4);
for I[1]:=1 to 2 do
for I[2]:=1 to 8 do
if (XO[V[I[2]].N[1]]=OX[I[1]]) and (XO[V[I[2]].N[2]]=OX[I[1]]) and (XO[V[I[2]].N[3]]=OX[I[1]]) then begin
ch:='Q';
Writeln; writeln('O jogador ',OX[I[1]],' Ganhou!');
AD:=True;
JogoNovo;
if OX[I[1]] = 'X' then
Placar(2);
if OX[I[1]] = 'O' then
Placar(3);
move;
end;
I[2]:=0;
for I[1]:=1 to 9 do
if not (XO[I[1]]=#0) then
I[2]:=I[2]+1;
if I[2] = 9 then begin
ch:='Q';
writeln; writeln('O jogo empatou!');
AD:=True;
JogoNovo;
Placar(1);
move;
end;
end;

function verifyX(X: Char): Boolean;
begin
if X = #0 then
verifyX:=True else
verifyX:=False;
end;

function VerJogador(J: Char): Char;
begin
if J = 'X' then
VerJogador:='O';
if J = 'O' then
VerJogador:='X';
end;

procedure InsertXO;
var I: Integer;
begin
for I:= 1 to 9 do begin
if XO[I] = 'X' then
ponto(I,0);
if XO[I] = 'O' then
ponto(I,2);
end;
end;

procedure move;
var J:Char;
    I: Integer;
begin
I:=1;
Ch:=#0;
J:='O';
repeat
if keypressed then begin
Ch:=ReadKey;
ponto(I,3);
case ch of
#13: begin
if MC = 1 then
if verifyX(XO[I]) then begin
J:=VerJogador(J);
XO[I]:= J;
end;
if MC = 2 then
J:=VerJogador(J); If verifyX(XO[I]) then begin
XO[I]:= 'X';
XO[AI]:='O';
end;
end;
'n': JogoNovo;
'6': begin
if I = 9 then
I:=0; I:=I+1; end;
'4': begin
if I = 1 then
I:=10; I:=I-1; end;
#27: Init;
end;
verificar;
InsertXO;
ponto(I,1);
end;
until UpCase(ch)='Q';
end;

procedure BackGround;
begin
TextBackGround(1);
TextColor(15);
ClrScr;
end;

procedure Sair;
begin
Ch:='q';
BackGround;
clrscr;
writeln('Saindo...');
delay(2000);
clrscr;
Exit;
end;

procedure Menu;
var Op: Integer;
begin
delay(8000);
clrscr;
writeln;
writeln('Jogo da Velha para PX-DOS(R) versao ' , versaoapp);
writeln;
writeln;
writeln('Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes');
writeln;
writeln;
writeln('Aplicativo exclusivo para PX-DOS(R).');
writeln;
writeln;
WriteLn('Escolha um modo de jogo:');
Writeln;
Writeln('[1] - Usuario X Usuario');
WriteLn('[2] - Usuario X PX-DOS(R)');
WriteLn('[3] - Versao deste programa');
WriteLn('[4] - Fechar jogo e voltar ao PX-DOS(R)');
WriteLn;
WriteLn;
write('Opcao: ');ReadLn(Op);
Case op of
1: begin
MC:=1;
JogoNovo;
move;
end;
2: begin
MC:=2;
JogoNovo;
move;
end;
3: VERSAO;
4: Sair;
end;
end;

procedure VERSAO;
begin
clrscr;
writeln;
writeln('Jogo da Velha para PX-DOS(R) versao ', versaoapp);
writeln;
writeln;
writeln('Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes');
writeln;
writeln;
writeln('Pressione qualquer tecla para continuar...');
readkey;
init;

end;

procedure Placar(VXOE: Integer);
begin
if VXOE = 1 then
EVXO.E:=EVXO.E+1;
if VXOE = 2 then
EVXO.VX:=EVXO.VX+1;
if VXOE = 3 then
EVXO.VO:=EVXO.VO+1;
TextColor(15);
GotoXY(1,1);
Writeln('Placar');
writeln;
writeln('Vitorias do Jogador: ', EVXO.VX);
writeln('Vitorias do PX-DOS: ', EVXO.VO);
writeln('Empates: ', EVXO.E);
end;

begin
Init;
end. 
