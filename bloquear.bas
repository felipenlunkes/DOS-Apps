10 cls
11 DIM VERSAO$(30)
12 VERSAO$="0.9.0"
20 print ""
30 cls
40 locate 2,1
50 print "Bloqueador de Area de trabalho do PX-DOS(R) versao " VERSAO$
51 print ""
52 print "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes"
58 print " "
60 print " "
70 DIM valorusuario$(30), valorpedido$(30)
80 print "Por seguranca, escolha uma senha forte, com no minimo 6 caracteres."
81 print ""
82 print "Para bloquear seu computador, insira uma senha de bloqueio valida:"
85 print ""
90 input valorusuario$
100 cls
110 locate 2,1
111 print "Bloqueador de Area de trabalho do PX-DOS(R) versao " VERSAO$
112 print ""
113 print "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes"
114 print ""
115 print ""
120 print "Computador bloqueado com senha."
130 print ""
140 print "Insira a senha pre-definida para desbloquear seu computador:"
145 print ""
150 input valorpedido$
160 if valorusuario$ = valorpedido$ goto 300
170 if valorusuario$ <> valorpedido$ goto 200
200 cls
201 print ""
202 print "Bloqueador de Area de trabalho do PX-DOS(R) versao " VERSAO$
203 print ""
204 print "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes"
205 print ""
206 print ""
210 print "A senha inserida para o desbloqueio esta incorreta."
220 print ""
222 print "Tente novamente a seguir."
223 print ""
224 print ""
225 print "Observe atentamente se a senha digitada esta correta e igual a senha definida."
226 print ""
230 goto 120
300 cls
310 print ""
320 locate 2,1
321 print "Bloqueador de Area de trabalho do PX-DOS(R) versao " VERSAO$
322 print ""
323 print "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes"
324 print ""
325 print ""
330 print "Senha correta."
340 print ""
341 print "A area de trabalho do PX-DOS foi desbloqueada com sucesso."
350 print ""
360 system


