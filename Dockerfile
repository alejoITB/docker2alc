################
#Dockerfile2alc
################

# Usamos Ubuntu 24.04 como base
FROM ubuntu:24.04

# Instalar paquetes necesarios, dependencias adicionales y recomendadas
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    dbus-x11 \
    policykit-1 \
    gnome-keyring \
    light-locker \
    xfce4-session \
    openssh-server \
    wget \
    python3 \
    python3-pip \
    sudo \
    net-tools \
    dbus-x11 \
    x11-utils \
    xdg-utils \
    libglib2.0-bin \
    && rm -rf /var/lib/apt/lists/*

# Configura el directorio vcn
RUN mkdir -p /root/.vnc

# Establece contraseña VNC (por defecto "password123", cambiala una vez creado el contenedor)
RUN printf "password123\npassword123\n" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Crea el archivo xstartup con la configuracion necesaria para la vision grafica
RUN echo '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
export XDG_SESSION_TYPE=x11\n\
export GNOME_KEYRING_CONTROL=\n\
export SSH_AUTH_SOCK=\n\
exec startxfce4' > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

# Instalar Visual Studio Code y las claves gpg necesarias
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update \
    && apt-get install -y code

# Configurar SSH para acceder mediante contraseña
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "root:password" | chpasswd

# Exponer puertos necesarios para ssh y vnc
EXPOSE 22 5901

# Copia, da permiso y ejecuta el script start.sh con mas comandos necesarios
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]




