@echo off
title Montando codigos em Assembly e gerando Apps PX-DOS...
cls

REM Agora serão montados os aplicativos utilizando o NASM

nasm -fbin ajuda.asm -o ajuda.epx -O0 -DBIBLIOTECAS -DAPLICATIVO -DAPP
nasm -fbin appx.asm -o appx.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin asm.asm -o asm.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin mouse.asm -o mouse.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin cobra.asm -o cobra.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin cpu.asm -o cpu.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin data.asm -o data.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
REM nasm -fbin editor.asm -o editor.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin int90h.asm -o int90h.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
REM nasm -fbin pxdiag.asm -o pxdiag.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin pin.asm -o pin.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin desligar.asm -o desligar.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin reg.asm -o reg.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin audio.asm -o audio.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin teclado.asm -o teclado.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
REM nasm -fbin guia.asm -o guia.epx -O0 -DBIBLIOTECAS -DAPP -DCOM -DAPLICATIVO
nasm -fbin mem.asm -o mem.epx -O0 -DBIBLIOTECAS -DAPP -DEPX -DAPLICATIVO
nasm -fbin tela.asm -o tela.epx -O0 -DBIBLIOTECAS -DAPP -DEPX -DAPLICATIVO

REM Agora serão montados os que utilizam o TASM

tasm fogo.asm
tlink /Tdc fogo,fogo.com
rename fogo.com fogo.epx

REM Agora os arquivos objeto e de mapa serão apagados (não são necessários)

del *.obj
del *.map
echo.

REM Agora o Painel de Controle do PX-DOS® serão gerado

cd "Painel de Controle"
nasm -fbin painel.asm -o painel.epx -O0 -DBIBLIOTECAS -DAPP -DEPX -DAPLICATIVO

REM Uma pausa para que possa ser possível verificar a presença de erros

pause