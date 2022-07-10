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
// Jogo Tetris para PX-DOS®
//
// Copyright © 2012-2016 Felipe Miguel Nery Lunkes
//
//***********************************************************************
}

Program tetris;
 
 uses DOS, Crt, Drivers;
 
 Const
    HEIGHT = 20;          
    HeightPlusOne = 21;   
    WIDTH = 11;           
    WidthPlusOne = 12;    

    LEFT = -1;            
    RIGHT = 1;            
      


 Type

    T_coordinate = record            
                     x : integer;
                     y : integer;
                   end;

    T_objgrid = array[1..4, 1..4] of boolean;   
                                                
                                               
                                                          

    T_grid = record                 
               status : boolean;    
               color  : integer;    
             end;

    T_object = record                   
                 pos  : T_coordinate;   
                 cell  : T_objgrid;       
                 size  : integer;         
                 color : integer;       
               end;







 Var

    grid : array[0..WidthPlusOne, 0..HeightPlusOne] of T_grid;    
    obj  : T_object;                                          
    next : T_object;                                           

    level : integer;             
    score : integer;            

    cycle : record
              freq   : integer;    
              status : integer;    
              step   : integer;    
                                   
            end;                   

    orig      : T_coordinate;    
    gameover  : boolean;        
    quit      : boolean;        

    i, j      : integer;   
    c         : char;      






 { ------------------------------------------------------------------
    Procedure Xclrscr: Fornecidos 4 pontos x1, y1, x2, y2, limpa uma
    área na tela equivalente ao retângulo de vértices superior
    direito = (x1, y1) e inferior esquerdo = (x2, y2).
    
    Equivale a:     window( x1, y1, x2, y2 );
                    clrscr;
   ------------------------------------------------------------------ }

 Procedure Xclrscr( x1, y1, x2, y2 : integer );

    Var x, y : integer;

    Begin
    for y := y1 to y2 do
        begin
        gotoxy(x1, y);
        for x := x1 to x2 do
            write(' ');
        end;
    End;
     


 { ------------------------------------------------------------------
    Function shock: Verifica se a peça está livre para mover-se
    horizontalmente xmov unidades e verticalmente ymov unidades.
   ------------------------------------------------------------------ }

 Function shock( xmov, ymov : integer ): boolean;

    Var i, j   : integer;
        return : boolean;

    Begin
    gotoxy(1,1);
    return := FALSE;
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (obj.cell[i,j])
                and (obj.pos.x + i + xmov >= 0)
                and (obj.pos.x + i + xmov <= WIDTH+1)
                and (grid[obj.pos.x+i+xmov, obj.pos.y+j+ymov].status)   
                then return := TRUE;
    shock := return;
    End;



 { ------------------------------------------------------------------
    Procedure rotate: Roda a peça no sentido horário, se possível.
   ------------------------------------------------------------------ }

 Procedure rotate;

    Var i, j : integer;
        old  : T_objgrid;

    Begin
    for i := 1 to 4 do
        for j := 1 to 4 do
            old[i,j] := obj.cell[i,j];

    for i := 1 to obj.size do
        for j := 1 to obj.size do
            obj.cell[i,j] := old[j,obj.size+1-i];

    if (shock(0,0)) then
        for i := 1 to 4 do
            for j := 1 to 4 do
                obj.cell[i,j] := old[i,j];
    End;



 { ------------------------------------------------------------------
    Procedure move: Move a peça para a direita ou para a esquerda,
    se possível.
   ------------------------------------------------------------------ }

 Procedure move( xmov : integer );

    Begin
    if (not shock(xmov, 0))
        then obj.pos.x := obj.pos.x + xmov;
    End;



 { ------------------------------------------------------------------
    Procedure consolidate: Prende a peça ao local onde ela se
    encontra. Após isso, a peça perde seu status de peça e passa a
    ser apenas parte do grid. Este procedimento é chamado quando a 
    peça chega ao fundo do grid, ou encontra com outra abaixo dela.
   ------------------------------------------------------------------ }

 Procedure consolidate;

    Var i, j : integer;

    Begin
        for i := 1 to 4 do
            for j := 1 to 4 do
                if (obj.cell[i,j]) then
                    begin
                    grid[obj.pos.x+i, obj.pos.y+j].status := TRUE;
                    grid[obj.pos.x+i, obj.pos.y+j].color := obj.color;
                    end;
    End;



 { ------------------------------------------------------------------
    Procedure checklines: Checa se alguma linha do grid foi
    completada. Se sim, apaga o conteudo dela, trazendo todas as
    linhas acima para baixo (as linhas que estão acima da que foi
    completada 'caem'). Também recalcula o score, o level e o
    cycle.freq.
   ------------------------------------------------------------------ }

 Procedure checklines;

    Var i, j, down  : integer;
        LineCleared : boolean;

    Begin
    down := 0;

    for j := HEIGHT downto 1 do
        begin
        LineCleared := TRUE;

        for i := 1 to WIDTH do
            if not (grid[i,j].status)
                then LineCleared := FALSE;

        if (LineCleared)
            then
                begin
                down := down + 1;
                score := score + 10;
                end
            else
                for i := 1 to WIDTH do
                    begin
                    grid[i,j+down].status := grid[i,j].status;
                    grid[i,j+down].color := grid[i,j].color;
                    end;
        end;

        level := score div 200;
        cycle.freq := trunc( 500 * exp(level*ln(0.85)) );
        textcolor(YELLOW);
        gotoxy( orig.x + (WIDTH+2)*2 + 18, orig.y + 15 );
        write(level);
        gotoxy( orig.x + (WIDTH+2)*2 + 30, orig.y + 15 );
        write(score);
        End;



 { ------------------------------------------------------------------
    Procedure hideobj: esconde a peça da tela.
   ------------------------------------------------------------------ }

 Procedure hideobj( obj : T_object );

    Var i, j : integer;

    Begin
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (obj.cell[i,j]) then
                begin
                gotoxy( orig.x + (obj.pos.x + i) * 2, orig.y + obj.pos.y+j );
                write('  ');
                end;
    gotoxy( orig.x, orig.y );
    End;



 { ------------------------------------------------------------------
    Procedure drawobj: desenha a peça na tela.
   ------------------------------------------------------------------ }

 Procedure drawobj( obj : T_object );

    Var i, j : integer;

    Begin
    textcolor(obj.color);
    for i := 1 to 4 do
        for j := 1 to 4 do
            if (obj.cell[i,j]) then
                begin
                gotoxy( orig.x + (obj.pos.x + i) * 2, orig.y + obj.pos.y + j );
                write(#219, #219);
                end;
    gotoxy( orig.x, orig.y );
    End;



 { ------------------------------------------------------------------
    Procedure refresh: redesenha todo o grid na tela.
   ------------------------------------------------------------------ }

 Procedure refresh;

    Var i, j : integer;

    Begin
    for i := 0 to WIDTH+1 do
        for j := 0 to HEIGHT+1 do
            begin
            gotoxy( orig.x + 2*i, orig.y + j );
            if (grid[i,j].status)
                then
                    begin
                    textcolor(grid[i,j].color);
                    write(#219, #219);
                    end
                else
                    write('  ');
            end;
    gotoxy( orig.x, orig.y );
    End;



 { ------------------------------------------------------------------
    Procedure createtgt: pega a peça já gerada anteriormente que está
    na caixa "next" (variável next) e a transforma na peça atual.
    Depois, gera nova peça randomicamente, posicionando-a na caixa
    "next".
   ------------------------------------------------------------------ }

 Procedure createtgt;

    Var i, j : integer;

    Begin

    hideobj(next);
    obj := next;

    obj.pos.x := WIDTH div 2 - 2;
    obj.pos.y := 0;

    next.pos.x := WIDTH + 4;
    next.pos.y := 6;

    for i := 1 to 4 do
        for j := 1 to 4 do
            next.cell[i,j] := FALSE;

    case random(7) of
        0: begin                   
           next.cell[2,2] := TRUE;
           next.cell[2,3] := TRUE;
           next.cell[3,2] := TRUE;
           next.cell[3,3] := TRUE;
           next.size := 4;
           next.color := WHITE;
           end;
        1: begin                  
           next.cell[2,1] := TRUE;
           next.cell[2,2] := TRUE;
           next.cell[2,3] := TRUE;
           next.cell[2,4] := TRUE;
           next.size := 4;
           next.color := LIGHTRED;
           end;
        2: begin                    
           next.cell[3,2] := TRUE;
           next.cell[1,3] := TRUE;
           next.cell[2,3] := TRUE;
           next.cell[3,3] := TRUE;
           next.size := 3;
           next.color := LIGHTGREEN;
           end;
        3: begin                    
           next.cell[1,2] := TRUE;
           next.cell[1,3] := TRUE;
           next.cell[2,3] := TRUE;
           next.cell[3,3] := TRUE;
           next.size := 3;
           next.color := LIGHTBLUE;
           end;
        4: begin                   
           next.cell[2,2] := TRUE;
           next.cell[2,3] := TRUE;
           next.cell[3,1] := TRUE;
           next.cell[3,2] := TRUE;
           next.size := 4;
           next.color := LIGHTCYAN;
           end;
        5: begin                 
           next.cell[2,2] := TRUE;
           next.cell[2,3] := TRUE;
           next.cell[3,3] := TRUE;
           next.cell[3,4] := TRUE;
           next.size := 4;
           next.color := LIGHTMAGENTA;
           end;
        6: begin                  
           next.cell[1,2] := TRUE;
           next.cell[2,1] := TRUE;
           next.cell[2,2] := TRUE;
           next.cell[2,3] := TRUE;
           next.size := 3;
           next.color := LIGHTGRAY;
           end;
        end;

    drawobj(next);

    End;



 { ------------------------------------------------------------------
    Procedure prninfo: imprime as informações presentes ao lado
    do grid (contorno da caixa "next" e comandos do jogo).
   ------------------------------------------------------------------ }

 Procedure prninfo( xpos, ypos : integer );

    Begin

   
    Xclrscr( xpos, ypos, 80, 24 );
    textcolor(WHITE);

    gotoxy( xpos, ypos+0 );
    write(#218, #196, #196, ' PROX ', #196, #196, #191);
    gotoxy( xpos, ypos+1 );
    write(#179, '          ', #179);
    gotoxy( xpos, ypos+2 );
    write(#179, '          ', #179);
    gotoxy( xpos, ypos+3 );
    write(#179, '          ', #179);
    gotoxy( xpos, ypos+4 );
    write(#179, '          ', #179);
    gotoxy( xpos, ypos+5 );
    write(#179, '          ', #179);
    gotoxy( xpos, ypos+6 );
    write(#179, '          ', #179);
    gotoxy( xpos, ypos+7 );
    write(#192, #196, #196, #196, #196, #196, #196, #196, #196, #196, #196, #217);
    textcolor(YELLOW);
    gotoxy( xpos, ypos+10 );
    write('       Nivel: 0    Pontos: 0');
    textcolor(WHITE);
    gotoxy( xpos, ypos+13 );
    write('Tetris para PX-DOS(R) versao 1.0');
    gotoxy( xpos, ypos+14 );    
    write('');    
    gotoxy( xpos, ypos+16 );
    write('Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes');


    gotoxy( xpos+17, ypos+1 );
    write('Controles:');
    gotoxy( xpos+17, ypos+2 );
    write('  Mover : [setas]');
    gotoxy( xpos+17, ypos+3 );
    write('  Girar : [Espaco]');
    gotoxy( xpos+17, ypos+4 );
    write('  Derrubar Peca : [ENTER]');
    gotoxy( xpos+17, ypos+5 );
    write('  Pausa : "P"');
    gotoxy( xpos+17, ypos+6 );
    write('  Sair  : [ESC]');
  
  

    End;



 { ------------------------------------------------------------------
    Procedure prnGameover: imprime mensagem de "game over" ao lado
    do grid.
   ------------------------------------------------------------------ }

 Procedure prnGameover( xpos, ypos : integer );

    Begin

   
    Xclrscr( xpos, ypos, 80, 24 );
    textcolor(WHITE);

    gotoxy( xpos, ypos+2 );
    writeln('    * * *   FIM DE JOGO  * * *');
    gotoxy( xpos, ypos+6 );
    write('Deseja iniciar um ');
    textcolor(LIGHTRED);
    write('N');
    textcolor(WHITE);
    write('ovo jogo ou ');
    textcolor(LIGHTRED);
    write('S');
    textcolor(WHITE);
    write('air?');
    

    End;






{ ------------------------------------------------------------------
                         PROGRAMA PRINCIPAL
   ------------------------------------------------------------------ }

 Begin

 randomize;

 orig.x := 2;
 orig.y := 2;

 clrscr;
 gotoxy( orig.x + (WIDTH+2)*2 + 5, orig.y + 1 );
 textcolor(WHITE);
 write('> > >  PX-DOS(R) Tetris  < < <');

 repeat

    prninfo( orig.x + (WIDTH+2)*2 + 4, orig.y + 5 );

    for i := 0 to WIDTH+1 do             
        for j := 0 to HEIGHT+1 do
            begin
            grid[i,j].status := TRUE;
            grid[i,j].color := DARKGRAY;
            end;

    for i := 1 to WIDTH do               
        for j := 1 to HEIGHT do          
            grid[i,j].status := FALSE;

    refresh;

    gameover := FALSE;
    quit := FALSE;
    cycle.freq := 500;
    cycle.step := 50;
    cycle.status := 0;
    score := 0;
    createtgt;
    createtgt;
    refresh;

    while not (gameover or quit) do
        begin

        if (keypressed) then   
            begin             

            case upcase(readkey) of
                #0: case (readkey) of
                       #75: begin         
                            hideobj(obj);
                            move(left);
                            drawobj(obj);
                            end;
                       #77: begin           
                            hideobj(obj);
                            move(right);
                            drawobj(obj);
                            end;
                       #80: cycle.status := 0;    
                            end;
               #13: begin                     
                    while (not shock(0,1)) do
                        obj.pos.y := obj.pos.y + 1;
                    cycle.status := 0;
                    end;
               #27: quit := TRUE;  
               #32: begin           
                    hideobj(obj);
                    rotate;
                    drawobj(obj);
                    end;
               'P': begin
                    textbackground(LIGHTGRAY);
                    for i := 1 to WIDTH do
                        for j := 1 to HEIGHT do
                            begin
                            gotoxy( orig.x + 2*i, orig.y + j );
                            write('  ');
                            end;
                    textbackground(BLACK);
                    textcolor(LIGHTGRAY);
                    gotoxy( orig.x + WIDTH - 2, orig.y + HEIGHT div 2 - 1 );
                    write('       ');
                    gotoxy( orig.x + WIDTH - 2, orig.y + HEIGHT div 2 );
                    write(' PAUSE ');
                    gotoxy( orig.x + WIDTH - 2, orig.y + HEIGHT div 2 + 1 );
                    write('       ');
                    gotoxy( orig.x, orig.y );
                    repeat
                        c := upcase(readkey);
                    until (c = 'P') or (c = #27);
                    if (c = #27) then quit := TRUE;
                    refresh;
                    drawobj(obj);
                    end;
               end;
            end;

        if (cycle.status < cycle.step) then   
            begin                             
            hideobj(obj);        
            if (shock(0,1))
                then               
                    begin        
                    consolidate;      
                    checklines;       
                    refresh;         
                    createtgt;      
                    if shock(0, 0) then gameover := TRUE;  
                    end                                    
                else              
                    obj.pos.y := obj.pos.y + 1;    
            drawobj(obj);          
            end;

        cycle.status := (cycle.status + cycle.step) mod cycle.freq;
        delay(cycle.step);

        end;

    if (quit) then break;

    prnGameover( orig.x + (WIDTH+2)*2 + 4, orig.y + 5 );
    repeat
        c := upcase(readkey);
    until (c = 'N') or (c = 'S');

 until (c = 'S');
 
 clrscr;
 gotoxy( 25, 12 );
 textcolor(WHITE);
 write('Pressione [ENTER] para sair . . .');

 End.
