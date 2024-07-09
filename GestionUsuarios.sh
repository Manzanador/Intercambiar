#!/bin/bash

ValidarNombre() {
if [ -z $Nom ] || [ `echo $Nom | wc -m` -ge 32 ] || echo $Nom | cut -c1 | egrep -q [0-9] || echo $Nom | grep -q '\$' || echo $Nom | grep -q '\*' || echo $Nom | grep -q '\?' || echo $Nom | grep -q '\[' || echo $Nom | grep -q '\]' || echo $Nom | grep -q '\""' || echo $Nom | grep -q '\/' || echo $Nom | grep -q '\&' || echo $Nom | grep -q '\;' || echo $Nom | grep -q '\^' || echo $Nom | egrep -q "\(" || echo $Nom | egrep -q "\)" || echo $Nom | egrep -q '<' || echo $Nom | egrep -q '>' || echo $Nom | egrep -q "\\|" || echo $Nom | egrep -q "'" || echo $Nom | egrep -q " "
then
return 0
else
return 1
fi
}

ValidarExistencia() {
if cut -f1 -d: $1 | egrep -w -q $2 && [ -n $2 ]
then
return 0
else
return 1
fi
}

ValidarPertenenciaGrupo() {
test=`egrep -w $Grp:x:[0-9]*:* /etc/group | tr , " " | wc -w`
test2=`expr $test + 1`
for (( var=1; var<$test2; var++ ))
do
if egrep -w $Grp:x:[0-9]*:* /etc/group | cut -f4 -d: | cut -f$var -d, | grep -w -q $Nom
then
return 1
break
fi
done
return 0
}

while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Crear un usuario"
echo "2) Eliminar un usuario"
echo "3) Asignar contraseña a un usuario"
echo "4) Crear un grupo"
echo "5) Eliminar un grupo"
echo "6) Asignar grupo secundario a un usuario"
echo "7) Eliminar usuario de grupo secundario"
echo "8) Establecer descripcion de un usuario"
echo "9) Ver lista de usuarios"
echo "10) Ver lista de grupos con participantes"
echo "0) Salir"
read -p "Ingrese una opcion: " OP
case $OP in
1) read -p "Ingrese el nombre del usuario a crear: " Nom
if echo $Nom | egrep -q " " || cut -f1 -d: /etc/passwd | egrep -q -w  $Nom || ValidarNombre $Nom
then
echo "El nombre de usuario ingresado no es valido"
else
read -p "Ingrese la contraseña a asignar: " Pswd
if [[ -n $Pswd ]]
then
sudo useradd -d/home/$Nom $Nom 
echo $Pswd | sudo passwd --stdin $Nom > /dev/null
echo "Usuario creado con exito"
else
echo "La contraseña ingresada no puede ser vacia"
fi
fi
sleep 2;;
2) read -p "Ingrese el nombre de usuario a eliminar: " Nom
if ValidarExistencia /etc/passwd $Nom
then
sudo userdel -r $Nom
echo "Usuario eliminado con exito"
else
echo "El nombre de usuario ingresado no se corresponde con uno del sistema o es vacio"
fi
sleep 2;;
3)  read -p "Ingrese el nombre del usuario cuya contraseña va a establecer: " Nom
if  cut -f1 -d: /etc/passwd | egrep -w -q $Nom && [ -n $Nom ]
then
read -p "Ingrese la contraseña a asignar: " Pswd
if [[ -n $Pswd ]]
then
echo $Pswd | sudo passwd --stdin $Nom
echo "Contraseña actualizada con exito"
else
echo "La contraseña a ingresar no puede ser vacia"
fi
else
echo "El nombre de usuario ingresado no se corresponde con un usuario del sistema o es vacio"
fi
sleep 2;;
4) read -p "Ingrese el nombre del grupo a crear: " Nom
if cut -f1 -d: /etc/group | egrep -q -w $Nom || ValidarNombre $Nom
then
echo "El nombre de grupo ingresado no es valido"
else
sudo groupadd $Nom
echo "Grupo creado con exito"
fi
sleep 2;;
5) read -p "Ingrese el nombre del grupo a eliminar: " Nom
if ValidarExistencia /etc/group $Nom
then
if [[ -n `egrep -w $Nom:x:[0-9]*:* /etc/group | cut -f4 -d:` ]]
then
echo "El grupo no puede ser eliminado debido a que aun cuenta con participantes"
else
sudo groupdel $Nom
echo "Grupo eliminado con exito"
fi
else
echo "El nombre de grupo ingresado no se corresponde con uno del sistema o es vacio"
fi
sleep 2;;
6) read -p "Ingrese el nombre del usuario a ingresar en un grupo: " Nom
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese el nombre del grupo: " Grp
if ValidarExistencia /etc/group $Grp
then
if ValidarPertenenciaGrupo $Grp $Nom
then
sudo usermod -a -G $Grp $Nom
echo "Usuario ingresado con exito"
else
echo "El usuario ingresado ya pertenece al grupo ingresado"
fi
else
echo "El grupo ingresado no se corresponde con uno del sistema o es vacio"
fi
else
echo "El nombre de usuario ingresado no se corresponde con un usuario del sistema o es vacio"
fi
sleep 2;;
7) read -p "Ingrese el nombre del usuario a eliminar del grupo: " Nom
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese el nombre del grupo al que pertenece: " Grp
if ValidarExistencia /etc/group $Grp
then
if ValidarPertenenciaGrupo $Grp $Nom
then
echo "El usuario ingresado no pertenece al grupo ingresado"
else
sudo gpasswd -d $Nom $Grp
echo "Usuario eliminado con exito"
fi
else
echo "El grupo ingresado no se corresponde con uno del sistema o es vacio"
fi
else
echo "El nombre de usuario ingresado no se corresponde con un usuario del sistema o es vacio"
fi
sleep 2;;
8)read -p "Ingrese el usuario cuya descripcion va a establecer: " Nom
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese la descripcion a asignar: " Desc
sudo usermod -c $Desc $Nom
echo "Descripcion establecida con exito"
else
echo "El usuario ingresado no se corresponde con un usuario del sistema o es vacio"
fi
sleep 2;;
9)echo "Usuario / Descripcion"
egrep -w home /etc/passwd | cut -f1,5 -d: | tr : " "
sleep 5;;
10)echo "Grupo / Integrantes"
while var= read line
do
if [[ `echo $line | cut -f3 -d:` -ge 1000 ]] && !(ValidarExistencia /etc/passwd `echo $line | cut -f1 -d:`)
then
echo $line | cut -f1,4 -d: | tr : " "
fi
done < /etc/group
sleep 5;;
0)echo Adios;;
*) echo "La opcion ingresada no es valida"
sleep 2;;
esac
done
