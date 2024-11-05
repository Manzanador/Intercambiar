#!/bin/bash
#Bucle que mantiene el menu refrescandose hasta que el usuario decide salir
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Comprobar estado de la base de datos"
echo "2) Iniciar base de datos"
echo "3) Apagar base de datos"
echo "4) Reiniciar base de datos"
echo "5) Consultar usuarios de la base de datos"
echo "0) Salir"
read -p "Ingrese una opcion: " OP
#Estructura de bifurcacion que permite adaptar la actividad a aquella seleccionada por el usuario
case $OP in
#Consulta que el servicio de la base de datos este activo
1) if systemctl status mariadb | grep -q running
then
echo "La base de datos esta activa"
else
#Consulta que el servicio de la base de datos este apagado
if systemctl status mariadb | grep -q dead
then
echo "La base de datos esta apagada"
else
#Consulta que el servicio de la base de datos haya tenido un fallo
if systemctl status mariadb | grep -q failed
then
echo "La base de datos tuvo un error al iniciar"
fi
fi
fi
sleep 5;;
2) if systemctl status mariadb | grep -q running
then
echo "La base de datos ya esta iniciada"
else
#Intenta iniciar la base de datos y devuelve un mensaje en funcion del resultado de esa tarea
if sudo systemctl start mariadb -q
then
echo "Base de datos iniciada con exito"
else
echo "La base de datos tuvo un error intentando iniciar"
fi
fi
sleep 5;;
3)if systemctl status mariadb | grep -q dead
then
echo "La base de datos ya esta apagada"
else
if systemctl status mariadb | grep -q failed
then
echo "La base de datos esta en estado de error"
else
#Detiene la base de datos
sudo systemctl stop mariadb
echo "Base de datos apagada con exito"
fi
fi
sleep 2;;
4) if systemctl status mariadb | grep -q failed
then
echo "La base de datos esta en estado de error"
else
#Reinicia la base de datos
sudo systemctl restart mariadb
echo "Base de datos reiniciada con exito"
fi
sleep 2;;
5)if systemctl status mariadb | grep -q running
then
#Ingresa a la shell mysql y ejecuta una consulta para enseñar una lista de los usuarios activos y las ip que tienen habilitadas
sudo mysql --user=root --password=UsuarioITS -e 'select user, host from mysql.user;'
else
echo "La base de datos no esta activa"
fi
sleep 5;;
0)echo "Adios";;
*)echo "La opcion ingresada no es valida"
sleep 2;;
esac
done
