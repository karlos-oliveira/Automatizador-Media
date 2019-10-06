#!/bin/bash

#Descrição: Script para copiar os arquivos de séries e legendas baixados
# e os distribuirem em suas respectivas pastas 
#Autor: Carlos Oliveira
#Data: 15/11/2017
#Versão: 1.0

#TODO: testar nova versão e descomentar o mover e o escaneamento

_downloadDir="/home/pi/Public/Torrents/Completos"

ls "$_downloadDir" *.mkv *.srt > manolo.tmp

while read f
do 

_origem="$_downloadDir/$f"

_arquivo=$(echo $f | sed "s/\[eztv\]//");
_nomeSerie=$(echo "$_arquivo" | grep -oP "(\w+\W)+S\d{1,2}E\d{1,2}");
_temporada=$(echo "$_nomeSerie" | grep -oP ".S\d{1,2}E\d{1,2}")
_nomeSerie=$(echo "$_nomeSerie" | sed "s/$_temporada//g"  | sed "s/\./\ /g")
_temporada=$(echo "$_temporada" | grep -oP "S\d{1,2}" | sed "s/S//g")
_destino="/home/pi/Multimidia/Séries"
_nomePasta=$(ls $_destino | grep "$_nomeSerie" | head -1)
_auxDir=$(echo "$_destino/$_nomePasta/$((10#$_temporada))º Temporada")
_diretorioDes=$(echo "$_auxDir")
_destino=$(echo "$_diretorioDes/$_arquivo")

if [ -d "$_diretorioDes" ]; then
mv "$_origem" "$_destino"
fi

done < manolo.tmp

rm manolo.tmp

#export LD_LIBRARY_PATH=/usr/lib/plexmediaserver

#/usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan --refresh --section 6

