@echo off
title Compilando Fontes em C...
cls
mkapp regedit
mkapp calc
mkapp editar

tcc hex.c
del *.obj
rename hex.exe hex.epx
pause