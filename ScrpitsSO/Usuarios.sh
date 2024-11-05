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

ValidarExistencia() {
#Valida que el grupo o usuario ingresados existan previamente
if cut -f1 -d: $1 | egrep -w -q $2 && [ -n $2 ]
then
return 0
else
return 1
fi
}
#Inicia el bucle que permite operar el menu
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
#Muestra las opciones disponible
echo "1) Crear un usuario"
echo "2) Eliminar un usuario"
echo "3) Asignar contraseña a un usuario"
echo "4) Establecer descripcion de un usuario"
echo "0) Regresar"
read -p "Ingrese una opcion: " OP
case $OP in
1) read -p "Ingrese el nombre del usuario a crear: " Nom
#Comprueba que el nombre no tenga espacios, no corresponda a un usuario previamente existente y llama a la funcion ValidarNombre
if echo $Nom | egrep -q " " || cut -f1 -d: /etc/passwd | egrep -q -w  $Nom || ValidarNombre $Nom
then
echo "El nombre de usuario ingresado no es valido"
else
read -p "Ingrese la contraseña a asignar: " Pswd
#Comprueba que la contraseña ingresada no este vacia
if [[ -n $Pswd ]]
then
#Crea el usuario, le genera un directorio home y le asigna la contraseña
sudo useradd -d/home/$Nom $Nom 
echo $Pswd | sudo passwd --stdin $Nom > /dev/null
echo "Usuario creado con exito"
else
echo "La contraseña ingresada no puede ser vacia"
fi
fi
sleep 2;;
2) read -p "Ingrese el nombre de usuario a eliminar: " Nom
#Valida existencia de usuario ingresado
if ValidarExistencia /etc/passwd $Nom
then
#Elimina el usuario ingresado
sudo userdel -r $Nom
echo "Usuario eliminado con exito"
else
echo "El nombre de usuario ingresado no se corresponde con uno del sistema o es vacio"
fi
sleep 2;;
3)  read -p "Ingrese el nombre del usuario cuya contraseña va a establecer: " Nom
#Valida existencia del usuario ingresado
if  cut -f1 -d: /etc/passwd | egrep -w -q $Nom && [ -n $Nom ]
then
read -p "Ingrese la contraseña a asignar: " Pswd
#Valida que la contraseña no este vacia
if [[ -n $Pswd ]]
then
#Cambia la contraseña del usuario
echo $Pswd | sudo passwd --stdin $Nom > /dev/null
echo "Contraseña actualizada con exito"
else
echo "La contraseña a ingresar no puede ser vacia"
fi
else
echo "El nombre de usuario ingresado no se corresponde con un usuario del sistema o es vacio"
fi
sleep 2;;
4)read -p "Ingrese el usuario cuya descripcion va a establecer: " Nom
#Valida la existencia del usuario
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese la descripcion a asignar: " Desc
#Agrega la descripcion al usuario
sudo usermod -c $Desc $Nom
echo "Descripcion establecida con exito"
else
echo "El usuario ingresado no se corresponde con un usuario del sistema o es vacio"
fi
sleep 2;;
0)echo Adios;;
*) echo "La opcion ingresada no es valida"
sleep 2;;
esac
done
