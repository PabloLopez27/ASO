Parámetros implementados: -OutputPath, -LogPath, -SessionCode, -c.
Si no hay red, se usa la carpeta Documentos como ruta alternativa y se registra un aviso en el log.
El inventario se guarda en CSV en la ruta indicada por -OutputPath (o Documentos si falla).
Mejoras: comprobación de rutas y permisos, logs con códigos de sesión, control de errores de monitores y mensajes de progreso.
