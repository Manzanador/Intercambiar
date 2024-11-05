#!/bin/bash
ValidarNombre() {
#Valida que el nombre ingresado no contenga caracteres reservados por el SO, espacios en blanco ni numeros
if [ -z $Nom ] || [ `echo $Nom | wc -m` -ge 32 ] || echo $Nom | cut -c1 | egrep -q [0-9] || echo $Nom | grep -q '\$' || echo $Nom | grep -q '\*' || echo $Nom | grep -q '\?' || echo $Nom | grep -q '\[' || echo $Nom | grep -q '\]' || echo $Nom | grep -q '\""' || echo $Nom | grep -q '\/' || echo $Nom | grep -q '\&' || echo $Nom | grep -q '\;' || echo $Nom | grep -q '\^' || echo $Nom | egrep -q "\(" || echo $Nom | egrep -q "\)" || echo $Nom | egrep -q '<' || echo $Nom | egrep -q '>' || echo $Nom | egrep -q "\\|" || echo $Nom | egrep -q "'" || echo $Nom | egrep -q " "
then
return 0
else
return 1
fi
}
#Valida que la ip ingresada cuente con el formato correcto
ValidarIP() 
{
if echo $1 | egrep -q '192.168.3.[0-2][0-5][0-5]'
then
return 0
else
if echo $1 | egrep -q '192.168.3.[1-9][0-9][0-9]'
then
return 0
else
if echo $1 | egrep -q '192.168.3.[1-9][0-9]'
then
return 0
else
if echo $1 | egrep -q "192.168.3.[1-9]"
then
return 0
else
return 1
fi
fi
fi
fi
}
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Comprobar estado de la conexion a internet"
echo "2) Comprobar conexion con los equipos de la red local"
echo "3) Consultar informacion de red del servidor"
echo "4) Ver puertos abiertos"
echo "5) Ver puertos en escucha"
echo "6) Cambiar HostName"
echo "7) Mostrar reglas de IPTables"
echo "0) Salir"
read -p "Seleccione una opcion: " OP
case $OP in
#Realiza un ping a google para comprobar si el servidor cuenta con conexion a internet y comunica el resultado
1) if ping google.com -c 2 > /dev/null
then
echo "Conexion a internet activa"
else
echo "Conexion a internet caida"
fi
sleep 5;;
#Realiza un ping a la IP ingresada para comprobar si esta tiene conexion con el servidor y devuelve el resultado
2)read -p "Ingrese la IP cuya conexion quiere comprobar: " IP
if ValidarIP $IP
then
if ping $IP -c 2 > /dev/null
then
echo "Conexion con este equipo activa"
else
echo "Conexion con este equipo caida"
fi
else
echo "La IP ingresada no esta en el formato correcto"
fi
sleep 5;;
#Muestra informacion de interfaces del servidor y su hostname
3)echo "IP"
ip a | grep "192.168.3"
echo "Hostname"
hostname
sleep 10;;
#Muestra puertos abiertos del servidor
4)netstat -a
sleep 10;;
#Muestra puertos en estado de escucha del servidor
5)netstat -l -inet
sleep 10;;
#Comprueba si un nombre ingresado es valido y establece el nuevo nombre de host a dicho nombre
6)read -p "Ingrese el nuevo nombre de host: " Hst
if ValidarNombre $Hst
then
sudo hostname $Hst
echo "El hostname a sido cambiado con exito"
else
echo "El nombre de hostname no es valido"
fi
sleep 5;;
#Enseña las reglas listadas en el firewall de IPTables
7) sudo iptables --line -L
sleep 5;;
0) echo "Adios";;
*) echo "La opcion ingresada no es valida"
sleep 2;;
esac
done

