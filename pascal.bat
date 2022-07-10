@echo off
title Construindo aplicativos em Pascal
cls
echo.
echo Construindo aplicativos em Pascal para PX-DOS(R)...
echo.
echo.
tpc2 matrix.pas
tpc2 velha.pas
tpc2 tetris.pas
tpc2 pxfon.pas
rename matrix.exe matrix.epx
rename velha.exe velha.epx
rename tetris.exe tetris.epx
rename pxfon.exe pxfon.epx
echo.
echo.
pause
