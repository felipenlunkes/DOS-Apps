@echo off
title Compilando PXDSK...

tcc -IC:\Dev\INCAPPS -epxdsk.epx pxdsk.c
rename PXDSK.exe PXDSK.EPX
del *.obj


pause