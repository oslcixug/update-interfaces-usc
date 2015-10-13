# update-interfaces-usc
Script para actualizar configuración de rede en aulas USC


1. Copiar en disco duro. No funciona desde el USB.

2. Ejecutar obligatoriamente con sudo: 

...sudo bash update-net.sh

3. Para un equipo llamado, por ejemplo, e175a005h016l preguntará:

...EDIFICIO (175)
...VLAN (005 poner los tres dígitos)
...HOST (016 poner los tres dígitos)

...Presentará el nombre del equipo y padirá confirmación.

...IP del ROUTER (p.ej. 172.25.4.1)

4. Esperamos a que termine y reiniciamos.

5. Una vez reiniciado lo metemos en dominio:

	sudo adjoin -w rai.usc.es -u unAdministradorDeDominio@usc.es
	sudo reboot
