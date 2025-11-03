#!/bin/bash
#==============================================================
# Nombre: ejercicio1 
# Descripción: muestra saludo por pantalla
# Autor: Pablo Lopez
# Fecha: 03/11/2025
# Versión: 1.0
# Uso: 
# Comentarios: 
#==============================================================

if [ $# -eq 0 ]
then
    echo "no se han recibido parametros"
    exit 1 
fi

nombre=$1
echo "hola $nombre."