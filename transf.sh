#!/bin/bash

#Descrição: Script para copiar os arquivos de séries e legendas baixados
# e os distribuirem em suas respectivas pastas
#Autor: Carlos Oliveira
#Data criação: 15/11/2017
#Data Atualizaão: 06/10/2019
#Versão: 2.0

#TODO:
#
# 1-) Testar nova versão e descomentar o mover e o escaneamento
# 2-) Efetuar o tratamento dos erros (mais amigáveis)
# 3-) Fazer a transferencia de filmes
# 4-) Aceitar parametros para scanear, trasnf só filmes, só séries, etc

_downloadDir="/home/pi/Public/Torrents/Completos"

#_qtdLegendas=$(ls -la *.srt | grep -e "^-"|wc -l)
#_qtdEpisodios=$(ls -la *.mkv | grep -e "^-"|wc -l)

### Criando lista de episódios ###
ls "$_downloadDir" | grep '.mkv' > listaEpi.tmp
ls "$_downloadDir" | grep '.mp4' >> listaEpi.tmp
_qtdEpi=$(cat listaEpi.tmp | wc -l)

### Criando lista de legendas ###
(ls "$_downloadDir" | grep '.srt') > listaLeg.tmp
_qtdLeg=$(cat listaLeg.tmp | wc -l)

echo -e "\\nIniciando transferencia de episódios..."
### Leitura dos  Episodios ###
while read f;
do 

_origem="$_downloadDir/$f"

_arquivo=$(echo "$f" | sed "s/\[eztv\]//");
_nomeSerie=$(echo "$_arquivo" | grep -oP "(\w+\W)+S\d{1,2}E\d{1,2}");
_temporada=$(echo "$_nomeSerie" | grep -oP ".S\d{1,2}E\d{1,2}")
_nomeSerie=$(echo "$_nomeSerie" | sed "s/$_temporada//g"  | sed "s/\./\ /g")
_temporada=$(echo "$_temporada" | grep -oP "S\d{1,2}" | sed "s/S//g")
_destino="/home/pi/Multimidia/Séries"
_nomePasta=$(ls $_destino | grep "$_nomeSerie" | head -1)
_auxDir=$(echo -e "$_destino/$_nomePasta/$((10#$_temporada))º Temporada")
_diretorioDes=$(echo "$_auxDir")
_destino=$(echo "$_diretorioDes/$_arquivo")

if [ -d "$_diretorioDes" ]; then
mv "$_origem" "$_destino"

contEpi=$(($contEpi + 1))
echo -ne "\\r$contEpi de $_qtdEpi episódio(s) transferidos"
fi

done < listaEpi.tmp

echo -e "\\n\\nIniciando transferencia de legendas..."
### Leitura das Legendas ###
while read f;
do

_origem="$_downloadDir/$f"

_arquivo=$(echo "$f" | sed "s/\[eztv\]//");
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

contLeg=$(($contLeg + 1))
echo -ne "\\r$contLeg de $_qtdLeg legenda(s) transferidas"
fi

done < listaLeg.tmp

echo -e "\\n"

### Removendo Arquivos Temporarios ###
rm listaEpi.tmp
rm listaLeg.tmp


### Efetuando o Scan das Bibliotecas ###

#export LD_LIBRARY_PATH=/usr/lib/plexmediaserver

#/usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan --refresh --section 6

