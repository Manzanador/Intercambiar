#!/bin/bash
ValidarExistencia()
{
if cut -d: -f1 /etc/passwd | egrep -w -q $1 && [ -n $1 ]
then
return 0
else
return 1
fi
}
while [ "$OP" != 0 ]
do
echo "1) Historial de inicios de sesion"
echo "2) Intentos de inicios de sesion fallidos"
echo "3) Transacciones realizadas en la base de datos"
echo "4) Manipulacion de usuarios"
echo "5) Manipulacion de grupos"
echo "6) Creacion de respaldos"
echo "7) Recuperacion de respaldos"
echo "8) Ver ultimos 20 comandos ejecutados por un usuario"
echo "0) Salir"
read -p "Ingrese una opcion: " OP
case $OP in
1) read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. Enter para continuar"
last -F | more
read -p "Historial de logins completado. Presione enter para continuar"
sleep 2;;
2) read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. Enter para continuar"
sudo lastb -F -i -f /var/log/btmp
read -p "Historial de logins fallidos completado. Presione enter para continuar"
sleep 2;;
3) read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. El numero visualizado al final de cada linea representa el codigo con el que termino la sentencia. Cualquier numero distinto de 0 representa un error. Enter para continuar"
sudo cat /var/lib/mysql/audit.log | more
read -p "Historial de transacciones con la BD completado. Presione enter para continuar"
sleep 2;;
4)read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. Enter para continuar"
sudo cat /var/log/secure | egrep -e /useradd -e /userdel -e /usermod -e /passwd | egrep PWD | egrep -v "\-a \-G" | more
read -p "Historial de manipulacion de usuarios completado. Presione enter para continuar"
sleep 2;;
5)read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. Enter para continuar"
sudo cat /var/log/secure | egrep -e /groupadd -e /groupdel -e "/usermod -a -G" -e gpasswd | egrep PWD | more
read -p "Historial de manipulacion de grupos completado. Presione enter para continuar"
sleep 2;;
6)read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. Enter para continuar"
sudo cat /var/log/CreacionRespaldos.log | more
read -p "Historial de creacion de respaldos completado. Presione enter para continuar"
sleep 2;;
7)read -p "Presione q en cualquier momento para terminar con la visualizacion del historial. Enter para continuar"
sudo cat /var/log/RecuperacionRespaldos.log | more
read -p "Historial de recuperacion de respaldos completado. Presione enter para continuar"
sleep 2;;
8) read -p "Ingresar el nombre de usuario cuyos ultimos 20 comandos quiere consultar: " Nom
if ValidarExistencia $Nom
then
sudo tail -n 20 "/home/$Nom/.bash_history" | more
else
echo "El nombre de usuario ingresado no concuerda con ningun usuario del sistema"
fi
read -p "Presione enter para continuar"
sleep 2;;
0) echo "Adios";;
esac
done
