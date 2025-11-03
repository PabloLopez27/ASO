#!/bin/bash
#==============================================================
# Nombre: 
# Descripción: 
# Autor: 
# Fecha: 
# Versión: 
# Uso: 
# Comentarios: 
#==============================================================

if [ $# -eq 0 ]
then
    echo "no se han recibido parametros"
    exit 1 
fi

nombre=$1
echo="hola $nombre."