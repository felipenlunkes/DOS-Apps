' Valores numéricos para as teclas e para a barra de espaço
CONST CIMA = 72, BAIXO = 80, ESQD = 75, DRT = 77
CONST CMESQ = 71, CMDRT = 73, BXESQ = 79, BXDRT = 81
CONST BARRAESP = " "


Null$ = CHR$(0)

' Plot$ = "" Linhas plotadas; Plot$ = "B" Significa mover
' o cursor para escrever as linhas
Plot$ = ""
CLS
PRINT " "
PRINT " "

PRINT "Use o cursor para desenhar em seu tela."
PRINT "Pressione <ESPACO> para ativar e desativar a tinta..."
PRINT "Pressione <ENTER> para comecar e <Q> para sair."
PRINT " "
PRINT " "
PRINT " "
PRINT " "
PRINT " "
PRINT " "
DO: LOOP WHILE INKEY$ = ""

SCREEN 1
CLS

DO
   SELECT CASE KeyVal$
      CASE Null$ + CHR$(CIMA)
         DRAW Plot$ + "C1 U2"
      CASE Null$ + CHR$(BAIXO)
         DRAW Plot$ + "C1 D2"
      CASE Null$ + CHR$(ESQD)
         DRAW Plot$ + "C2 L2"
      CASE Null$ + CHR$(DRT)
         DRAW Plot$ + "C2 R2"
      CASE Null$ + CHR$(CMESQ)
         DRAW Plot$ + "C3 H2"
      CASE Null$ + CHR$(CMDRT)
         DRAW Plot$ + "C3 E2"
      CASE Null$ + CHR$(BXESQ)
         DRAW Plot$ + "C3 G2"
      CASE Null$ + CHR$(BXDRT)
         DRAW Plot$ + "C3 F2"
      CASE BARRAESP
         IF Plot$ = "" THEN Plot$ = "B " ELSE Plot$ = ""
      CASE ELSE
         ' Caso o usuário pressione alguma tecla não válida, não fazer nada
    
   END SELECT

   KeyVal$ = INKEY$

LOOP UNTIL KeyVal$ = "q"

SCREEN 0, 0
WIDTH 80
END
