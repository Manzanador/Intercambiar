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
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Crear un usuario"
echo "2) Eliminar un usuario"
echo "3) Asignar contraseña a un usuario"
echo "4) Asignar grupo secundario a un usuario"
echo "5) Eliminar usuario de grupo secundario"
echo "6) Establecer descripcion de un usuario"
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
4) read -p "Ingrese el nombre del usuario a ingresar en un grupo: " Nom
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
5) read -p "Ingrese el nombre del usuario a eliminar del grupo: " Nom
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
6)read -p "Ingrese el usuario cuya descripcion va a establecer: " Nom
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese la descripcion a asignar: " Desc
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
