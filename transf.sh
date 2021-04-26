#!/bin/bash

#Descrição: Script para copiar os arquivos de séries e legendas baixados
# e os distribuirem em suas respectivas pastas
#Autor: Carlos Oliveira
#Data criação: 15/11/2017
#Data Atualizaão: 26/4/2021
#Versão: 2.5

#TODO:
#
# 1-) Testar nova versão e descomentar o mover e o escaneamento
# 2-) Fazer a transferencia de filmes

helpFunction()
{
   echo ""
   echo "Exemplo de uso: transf.sh -o \"/diretorio/de/origem\" -d \"diretorio/de/destino\" -t 1"
   echo -e "\t-o Diretorio de origem"
   echo -e "\t-d Diretorio de destino"
   echo -e "\t-t Tipo de midia (1-Filme | 2-Serie)"
   echo -e "\t-s Scanear novas midias(plex) [Opcional | Defaut=false]"
   echo -e "\t-g Modo debug [Opcional | Default=false]"
   exit 1 
}

while getopts s:t:o:d:g:h: flag
do
    case "${flag}" in
        s) __scannear=${OPTARG};;
        t) __tipoMedia=${OPTARG};;
        o) __origemDir=${OPTARG};;
	d) __destinoDir=${OPTARG};;
	g) __debug=${OPTARG};;
	?) helpFunction;;
    esac
done

if [ -z "$__origemDir" ] || [ -z "$__destinoDir" ] || [ -z "$__tipoMedia" ]
then
   echo "Por favor informe todos os parametros obrigatorios";
   helpFunction
fi

### Criando lista de arquivos ###
ls "$__origemDir" >> listaArquivos.tmp

echo -e "\\nIniciando transferencia de arquivos..."

### Leitura dos Arquivos ###
while read f;
do 

_arquivo=$(echo "$f" | sed "s/\[eztv\]//");
_nomeSerie=$(echo "$_arquivo" | grep -oP "(\w+\W)+S\d{1,2}E\d{1,2}");
_temporada=$(echo "$_nomeSerie" | grep -oP ".S\d{1,2}E\d{1,2}")
_nomeSerie=$(echo "$_nomeSerie" | sed "s/$_temporada//g"  | sed "s/\./\ /g")
_temporada=$(echo "$_temporada" | grep -oP "S\d{1,2}" | sed "s/S//g")
_temporadaDirNome=$(echo "$((10#$_temporada))º Temporada")
_dirSerie=$(echo -e "$__destinoDir$_nomeSerie")

if [ ! -d "$_dirSerie" ]; then
mkdir "$_dirSerie"
chmod 777 "$_dirSerie"
echo -e "Criado diretório para a série '$_nomeSerie'"
fi

_temporadaDir=$(echo -e "$_dirSerie/$_temporadaDirNome")

if [ ! -d "$_temporadaDir" ]; then
mkdir "$_temporadaDir"
chmod 777 "$_temporadaDir"
echo -e "Criado o diretório para a $_temporadaDirNome da série '$_nomeSerie'"
fi

cp "$__origemDir$f" "$_temporadaDir$arquivo"

echo -e "$_arquivo copiado com sucesso"

done < listaArquivos.tmp
echo -e "\\n"

### Removendo Arquivos Temporarios ###
rm listaArquivos.tmp


### Efetuando o Scan das Bibliotecas ###
#if [ -z $__scannear ]; then
#export LD_LIBRARY_PATH=/usr/lib/plexmediaserver

#/usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan --refresh --section 6
#fi

