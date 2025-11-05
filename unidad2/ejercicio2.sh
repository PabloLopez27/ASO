#!/bin/bash
#==============================================================
# Nombre: ejercicio2
# Descripción: cuenta los archivos de un directorio
# Autor: Pablo Lopez
# Fecha: 05/11/2025
# Versión: 1.0
# Uso: 
# Comentarios: 
#==============================================================


directorio=${1:-.}

cantidad=$(find "$directorio" -maxdepth 1 -type f | wc -l)

echo "Hay $cantidad archivos en el directorio '$directorio'."
