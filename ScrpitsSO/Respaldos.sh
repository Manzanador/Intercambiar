#!/bin/bash
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Respladar totalidad del servidor"
echo "2) Respladar usuarios y grupos del servidor"
echo "3) Respaldar totalidad de la base de datos"
echo "4) Respaldar entidades de la base de datos"
echo "5) Respaldar configuracion de base de datos"
echo "6) Respaldar configuraciond de servidor SSH"
echo "7) Recuperaciones"
echo "0) Salir"
read -p "Seleccione una opcion: " OP
case $OP in
1) if sudo tar -czf /etc/Respaldos/RespaldoSO.tar.gz /
then
echo "Respaldo del SO realizado con exito"
echo Respaldo de SO realizado por $USER el `date` >> /var/log/CreacionRespaldos.log
else
echo "Fallo al realizar el respaldo del SO"
fi
sleep 5;;
2) if sudo gzip -cv /etc/passwd > $HOME/RespaldoUsuarios.gz && sudo gzip -cv /etc/group > $HOME/RespaldoGrupos.gz
then
sudo mv $HOME/RespaldoUsuarios.gz /etc/Respaldos/RespaldoUsuarios.gz && sudo mv $HOME/RespaldoGrupos.gz /etc/Respaldos/RespaldoGrupos.gz
echo "Respaldo de usuarios y grupos realizado con exito"
cat /var/log/CreacionRespaldos.log >> $HOME/CreacionRespaldos.log
echo Respaldo de usuarios y grupos realizado por $USER el `date` >> $HOME/CreacionRespaldos.log
sudo cp $HOME/CreacionRespaldos.log /var/log/CreacionRespaldos.log
else
echo "Fallo al realizar el respaldo de usuarios y grupos"
fi
sleep 5;;
3) mkdir -p /tmp/mysql
if sudo mv /etc/Respaldos/RespaldoBD.d /tmp/mysql/RespaldoBD.d && sudo mariabackup --backup --target-dir=/etc/Respaldos/RespaldoBD.d --user=Respaldos --password=123
then
echo "Respaldo de la base de datos exitoso"
cat /var/log/CreacionRespaldos.log >> $HOME/CreacionRespaldos.log
echo Respaldo completo de base de datos realizado por $USER el `date` >> $HOME/CreacionRespaldos.log
sudo cp $HOME/CreacionRespaldos.log /var/log/CreacionRespaldos.log
else
echo "Fallo al realizar el respaldo de la base de datos"
fi
sleep 5;;
4) sudo touch /etc/Respaldos/RespaldoEntidadesBD.sql
echo "use AIOMSdb;" > $HOME/RespaldoEntidadesBD.sql
if sudo mysqldump --user=Respaldos --password=123 -e -x AIOMSdb Persona Neumatico Cliente Trabajador Proveedor Vehiculo Miembro Mensual Sistematico >> $HOME/RespaldoEntidadesBD.sql && sudo mv $HOME/RespaldoEntidadesBD.sql /etc/Respaldos/RespaldoEntidadesBD.sql
then
echo "Respaldo de entidades de la base de datos exitoso"
cat /var/log/CreacionRespaldos.log >> $HOME/CreacionRespaldos.log
echo Respaldo de entidades de base de datos realizado por $USER el `date` >> $HOME/CreacionRespaldos.log
sudo cp $HOME/CreacionRespaldos.log /var/log/CreacionRespaldos.log
else
echo "Fallo al realizar el respaldo de entidades de la base de datos"
fi
sleep 5;;
5) if sudo gzip -cv /etc/my.cnf.d/mariadb-server.cnf > $HOME/ConfigsBDD.gz && sudo mv $HOME/ConfigsBDD.gz /etc/Respaldos/ConfigsBDD.gz
then
echo "Respaldo de configuracion de base de datos realizado con exito"
cat /var/log/CreacionRespaldos.log >> $HOME/CreacionRespaldos.log
echo Respaldo de configuracion de base de datos realizado por $USER el `date` >> $HOME/CreacionRespaldos.log
sudo cp $HOME/CreacionRespaldos.log /var/log/CreacionRespaldos.log
else
echo "Fallo al realizar el respaldo de configuracion de base de datos"
fi
sleep 2;;
6) if sudo gzip -cv /etc/ssh/sshd_config > $HOME/ConfigsSSH.gz && sudo mv $HOME/ConfigsSSH.gz /etc/Respaldos/ConfigsSSH.gz
then
echo "Respaldo de configuracion del servidor SSH realizado con exito"
cat /var/log/CreacionRespaldos.log >> $HOME/CreacionRespaldos.log
echo Respaldo de configuracion de ssh realizado por $USER el `date` >> $HOME/CreacionRespaldos.log
sudo cp $HOME/CreacionRespaldos.log /var/log/CreacionRespaldos.log
else
echo "Fallo al realizar el respaldo de configuracion del servidor SSH"
fi
sleep 2;;
7)Recuperacion.sh;;
esac
done
