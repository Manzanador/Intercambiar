#!/bin/bash
while [ "$OP" != 0 ]
do
#Muestra opciones
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Recuperar respaldo de usuarios y grupos del sistema"
echo "2) Recuperar respaldo de base de datos completa"
echo "3) Recuperar respaldo de entidades de base de datos"
echo "4) Recuperar respaldo de configuracion de base de datos"
echo "5) Recuperar configuracion de servicio SSH"
echo "0) Salir"
#Bifurca script en funcion de opcion seleccionada
read -p "Seleccione una opcion: " OP
case $OP in
#Intenta descifrar la copia de los archivos /etc/passwd y /etc/group en el directorio etc/Respaldos del usuario y luego copiarlos sobre los archivos actuales
1) if sudo gunzip -c /etc/Respaldos/RespaldoUsuarios.gz > $HOME/RespaldoUsuarios && sudo gunzip -c /etc/Respaldos/RespaldoGrupos.gz > $HOME/RespaldoGrupos
then
sudo cp $HOME/RespaldoUsuarios /etc/passwd
sudo cp $HOME/RespaldoGrupos /etc/group
echo "Respaldo recuperado con exito"
#Carga un registro de la realizacion del resplado en el archivo RecuperacionRespaldos
cat /var/log/RecuperacionRespaldos.log >> $HOME/RecuperacionRespaldos.log
echo Respaldo de usuarios y grupos recuperado por $USER el `date` >> $HOME/RecuperacionRespaldos.log
sudo cp $HOME/RecuperacionRespaldos.log /var/log/RecuperacionRespaldos.log
else
echo "Fallo al recuperar el respaldo"
fi
sleep 2;;
2) sudo systemctl stop mariadb
#Borra el posible contenido de la carpeta /tmp/mysql para asegurarse de que este vacia
rm -rf /tmp/mysql/*
mkdir -p /tmp/mysql
#Mueve la informacion de la base de datos a una carpeta auxiliar ubicada en /tmp/mysql
sudo mv /var/lib/mysql/* /tmp/mysql
#Restaura la informacion respaldada
sudo mariabackup --prepare --target_dir=/etc/Respaldos/RespaldoBD.d
if sudo mariabackup --copy-back --target-dir=/etc/Respaldos/RespaldoBD.d
then
#Da la propiedad de los nuevos archivos al usuario mysql
sudo chown -R mysql:mysql /var/lib/mysql
echo "Respaldo de la base de datos completado con exito"
#Carga un registro de la realizacion del resplado en el archivo RecuperacionRespaldos
cat /var/log/RecuperacionRespaldos.log >> $HOME/RecuperacionRespaldos.log
echo Respaldo de base de datos recuperado por $USER el `date` >> $HOME/RecuperacionRespaldos.log
sudo cp $HOME/RecuperacionRespaldos.log /var/log/RecuperacionRespaldos.log
else
#En caso de error, restaura la informacion anterior de la base de datos
sudo mv /tmp/mysql/* /var/lib/mysql
echo "Error recuperando el respaldo de la base de datos, volviendo a la informacion inicial"
fi
sudo systemctl start mariadb
sleep 2;;
#Intena utilizar el respaldo de entidades de la base de datos para restaurar estas tablas
3) if sudo mysql -uRespaldos -p123 < /etc/Respaldos/RespaldoEntidadesBD.sql
then
echo "Respaldo de las entidades de la base de datos recuperado con exito"
#Carga un registro de la realizacion del resplado en el archivo RecuperacionRespaldos
cat /var/log/RecuperacionRespaldos.log >> $HOME/RecuperacionRespaldos.log
echo Respaldo de entidades de base de datos recuperado por $USER el `date` >> $HOME/RecuperacionRespaldos.log
sudo cp $HOME/RecuperacionRespaldos.log /var/log/RecuperacionRespaldos.log
else
echo "Error intentando recuperar el respaldo de las entidades de la base de datos"
fi
sleep 2;;
4)sudo systemctl stop mariadb
#Intenta descomprimir el archivo que almacena el respaldo de la config del servicio de SSH en /etc/Respaldos y luego copiarlo sobre el archivo actual
if sudo gunzip -cv /etc/Respaldos/ConfigsBDD.gz > $HOME/ConfigsBDD
then
if sudo cp $HOME/ConfigsBDD /etc/my.cnf.d/mariadb-server.cnf
then
echo "Respaldo de la configuracion de mariadb recuperado con exito"
#Carga un registro de la realizacion del resplado en el archivo RecuperacionRespaldos
cat /var/log/RecuperacionRespaldos.log >> $HOME/RecuperacionRespaldos.log
echo Respaldo de config de mariadb recuperado por $USER el `date` >> $HOME/RecuperacionRespaldos.log
sudo cp $HOME/RecuperacionRespaldos.log /var/log/RecuperacionRespaldos.log
else
echo "Error al recuperar el respaldo de la configuracion de mariadb"
fi
else
echo "Error al recuperar el respaldo de la configuracion de mariadb"
fi
sudo systemctl start mariadb
sleep 2;;
5) sudo systemctl stop sshd
#Intenta descomprimir el archivo que almacena el respaldo de la config del servicio de SSH en /etc/Respaldos y luego copiarlo sobre el archivo actual
if sudo gunzip -cv /etc/Respaldos/ConfigsSSH.gz > $HOME/ConfigsSSH
then
if sudo cp $HOME/ConfigsSSH /etc/ssh/sshd_config
then
echo "Respaldo de la configuracion de OpenSSH recuperado con exito"
#Carga un registro de la realizacion del resplado en el archivo RecuperacionRespaldos
cat /var/log/RecuperacionRespaldos.log >> $HOME/RecuperacionRespaldos.log
echo Respaldo de config de OpenSSH recuperado por $USER el `date` >> $HOME/RecuperacionRespaldos.log
sudo cp $HOME/RecuperacionRespaldos.log /var/log/RecuperacionRespaldos.log
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
