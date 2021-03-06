#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Este script debe ser executado por root !!" 2>&1
  exit 1
fi

# Variables globais. Deben ser modificadas cos valores indicados para cada aula.
EDIFICIO=170
VLAN=009

# Na instalación da aula había un erro nas URL's dos repos de CRAN
# Modificacion de ficheiro r-cran.list
rm /etc/apt/sources.list.d/r-cran.list~
echo "deb http://ftp.cixug.es/CRAN/bin/linux/ubuntu precise/" > /etc/apt/sources.list.d/r-cran.list

# Para evitar posibles conflictos, paramos o servizo network-manager
service network-manager stop

# Deshabilitamos a xestión das interfaces de rede a través de Network Manager
sed -i -e "s/managed=true/managed=false/" /etc/NetworkManager/NetworkManager.conf

if cat /proc/net/dev | grep "eth0:" ; then

	INTERFACE="eth0"

else

	INTERFACE="eth1"
	sed -i -e "s/eth0/eth1/g" /etc/network/interfaces

fi

# Solución para o seguinte erro: zenity: Gtk-WARNING **: cannot open display
xhost local:$USER

PC=$(zenity --entry --text="- EDIFICIO - $EDIFICIO\n- VLAN - $VLAN\n\nIntroduce o número do equipo:" --title="Oficina de Software Libre")

# Se o usuario pulsa o botón Cancelar, hai que saír do script
if [ $? -ne 0 ] ; then
	exit 1
fi

HOSTNAME=$(zenity --entry --text="Introduce o nome do equipo:" --entry-text=e"$EDIFICIO"a"$VLAN"h"$PC"l --title="Oficina de Software Libre")

# Se o usuario pulsa o botón Cancelar, hai que saír do script
if [ $? -ne 0 ] ; then
	exit 1
fi

sed -i -e "s/address.*/address	172.25.9.$((10#$PC))/" /etc/network/interfaces
sed -i -e "s/dns -.*/dns-nameservers 192.168.40.21 192.168.40.12/" /etc/network/interfaces
sed -i -e "s/gateway.*/gateway	172.25.8.1/" /etc/network/interfaces

# Paramos a interface de rede, e volvemos a levantala coa nova configuración
ifdown $INTERFACE
ifup $INTERFACE

echo $HOSTNAME > /etc/hostname
sed -i -e "s/127.0.1.1.*/127.0.1.1	$HOSTNAME/" /etc/hosts

zenity --question --text="Completaronse todas as tarefas con éxito.\nQueres reiniciar o equipo?"

if [ $? -eq 0 ] ; then
	reboot
fi
