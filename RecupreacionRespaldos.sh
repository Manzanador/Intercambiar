#!/bin/bash
while [ "$OP" != 0 ]
do
echo "1) Recuperar respaldo de usuarios y grupos del sistema"
echo "2) Recuperar respaldo de base de datos completa"
echo "3) Recuperar respaldo de entidades de base de datos"
echo "4) Recuperar respaldo de configuracion de base de datos"
echo "5) Recuperar configuracion de servicio SSH"
echo "0) Salir"
read -p "Seleccione una opcion: " OP
case $OP in
1) if sudo gunzip -c /etc/Respaldos/RespaldoUsuarios.gz > /home/Gerente/RespaldoUsuarios && sudo gunzip -c /etc/Respaldos/RespaldoGrupos.gz > /home/Gerente/RespaldoGrupos
then
sudo cp /home/Gerente/RespaldoUsuarios /etc/passwd
sudo cp /home/Gerente/RespaldoGrupos /etc/group
echo "Respaldo recuperado con exito"
else
echo "Fallo al recuperar el respaldo"
fi
sleep 2;;
2) sudo systemctl stop mariadb
sudo rm -r /tmp/mysql
sudo mkdir -p /tmp/mysql
sudo mv /var/lib/mysql/* /tmp/mysql
sudo mariabackup --prepare --target_dir=/etc/Respaldos/RespaldoBD
if sudo mariabackup --copy-back --target-dir=/etc/Respaldos/RespaldoBD
then
sudo chown -R mysql:mysql /var/lib/mysql
echo "Respaldo de la base de datos completado con exito"
else
sudo mv /tmp/mysql/* /var/lib/mysql
echo "Error recuperando el respaldo de la base de datos, volviendo a la informacion inicial"
fi
sudo systemctl start mariadb
sleep 2;;
3) if sudo mysql -uroot -p12345678 < /etc/Respaldos/RespaldoEntidades.sql
then
echo "Respaldo de las entidades de la base de datos recuperado con exito"
else
echo "Error intentando recuperar el respaldo de las entidades de la base de datos"
fi
sleep 2;;
4)sudo systemctl stop mariadb
if sudo gunzip -cv /etc/Respaldos/ConfigsBDD.gz > /home/Gerente/ConfigsBDD
then
if sudo cp /home/Gerente/ConfigsBDD /etc/my.cnf.d/mariadb-server.cnf
then
echo "Respaldo de la configuracion de mariadb recuperado con exito"
else
echo "Error al recuperar el respaldo de la configuracion de mariadb"
fi
else
echo "Error al recuperar el respaldo de la configuracion de mariadb"
fi
sudo systemctl start mariadb
sleep 2;;
5) sudo systemctl stop sshd
if sudo gunzip -cv /etc/Respaldos/ConfigsSSH.gz > /home/Gerente/ConfigsSSH
then
if sudo cp /home/Gerente/ConfigsSSH /etc/ssh/sshd_config
then
echo "Respaldo de la configuracion de OpenSSH recuperado con exito"
else
echo "Error al recuperar el respaldo de la configuracion de OpenSSH"
fi
else
echo "Error al recuperar el respaldo de la configuracion de OpenSSH"
fi
sudo systemctl start sshd
sleep 2;;
0) echo "Adios";;
*) echo "La opcion ingresada no es valida";;
esac
done
