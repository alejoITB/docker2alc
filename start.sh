#!/bin/bash

# Iniciar DBus correctamente (requerido por Xfce)
dbus-daemon --system --fork

# Iniciar SSH
service ssh start

# Iniciar VNC server sin autenticación
# Recomendado establecer una contraseña una vez creado el contenedor
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no -SecurityTypes None --I-KNOW-THIS-IS-INSECURE

# Mantener el contenedor activo
tail -f /dev/null


