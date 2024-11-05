#!/bin/bash
#Valida que el usuario ingresado exista
ValidarExistencia() {
if cut -f1 -d: $1 | egrep -w -q $2 && [ -n $2 ]
then
return 0
else
return 1
fi
}
#Inicia el bucle que permite operar con las opciones
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Ver lista de usuarios"
echo "2) Ver lista de grupos con participantes"
echo "0) Regresar"
read -p "Ingrese una opcion: " OP
case $OP in
1)echo "Usuario / Descripcion"
#Comprueba que los usuarios tengan un directorio home(Para evitar mostrar usuarios de demonios del sistema), y de ser asi corta su nombre y descripcion de /etc/passwd y la muestra
egrep -w home /etc/passwd | cut -f1,5 -d: | tr : " "
sleep 5;;
2)echo "Grupo / Integrantes"
#Recorre el bucle mientras el archivo tenga lineas
while var= read line
do
#Toma la linea actual, se queda con el id de grupo y comprueba que sea superior a mil(para mostrar solo los grupos creados por el usuario), luego utiliza la funcion validar existencia para comprobar que usuarios pertenecen al grupo
if [[ `echo $line | cut -f3 -d:` -ge 1000 ]] && !(ValidarExistencia /etc/passwd `echo $line | cut -f1 -d:`)
then
#Muestra los usuarios que pertenecen al grupo
echo $line | cut -f1,4 -d: | tr : " "
fi
done < /etc/group
sleep 5;;
0)echo Adios;;
*) echo "La opcion ingresada no es valida"
sleep 2;;
esac
done
