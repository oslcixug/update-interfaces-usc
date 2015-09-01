#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Este script debe ser executado por root !!" 2>&1
  exit 1
fi

EDIFICIO=001
AULA=001

if cat /proc/net/dev | grep "eth0:" ; then

	INTERFACE="eth0"

else

	INTERFACE="eth1"
	sed -i -e "s/auto eth0/auto eth1/" /etc/network/interfaces
	sed -i -e "s/iface etho.*/iface eth1 inet static/" /etc/network/interfaces

fi

# Solución para o seguinte erro: zenity: Gtk-WARNING **: cannot open display
xhost local:$USER

PC=$(zenity --entry --text="- EDIFICIO - $EDIFICIO\n- AULA - $AULA\n\nIntroduce o número do equipo:" --title="Oficina de Software Libre")

HOSTNAME=$(zenity --entry --text="Introduce o nome do equipo:" --entry-text=e"$EDIFICIO"a"$AULA"h"$PC"l --title="Oficina de Software Libre")

sed -i -e "s/address.*/address	172.25.9.$PC/" /etc/network/interfaces
sed -i -e "s/dns -.*/dns-nameservers 192.168.40.12 192.168.40.21/" /etc/network/interfaces
sed -i -e "s/gateway.*/gateway	172.25.8.1/" /etc/network/interfaces

echo $HOSTNAME > /etc/hostname
sed -i -e "s/127.0.1.1.*/127.0.1.1	$HOSTNAME/" /etc/hosts

zenity --question --text="Completaronse todas as tarefas con éxito.\nQueres reiniciar o equipo?"

if [ $? -eq 0 ] ; then
	reboot
fi
