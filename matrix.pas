{
//***********************************************************************
//       ______
//      /  __  \      Sistema Operacional PX-DOS�
//     /  |__|  \     Copyright � 2013-2016 Felipe Miguel Nery Lunkes
//    /  _____   \    Todos os direitos reservados.  
//   /   /    \   \     
//  /___/      \___\  Aplicativos do sistema
//
//
// Compat�vel com PX-DOS� 0.9.0 ou superior   
//
//***********************************************************************
//
//
// Descanso de tela para PX-DOS�
//
// Copyright � 2012-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************
}

Program MATRIX;
Uses Crt;

Var
col,lin,ql,cont,aux:integer;
letra:char;

Begin

Clrscr;

Repeat

col:=1+Random(79);
lin:=1+Random(23);
ql:= Random(10);

for cont:= lin to lin+ql do
Begin

if cont<24 then
Begin

letra:= chr(Random(255));

for aux:=1 to 2 do
Begin

if aux= 1 Then
Textcolor(10)

else

Textcolor(2);
gotoxy(col,cont);
write(letra);
delay(35000);

end;
end;
end;

until keypressed;

clrscr;

end.
