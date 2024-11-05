#!/bin/bash
ValidarNombre() {
#Valida que el nombre ingresado no contenga caracteres reservadospor el SO, espacios en blanco ni numeros
if [ -z $Nom ] || [ `echo $Nom | wc -m` -ge 32 ] || echo $Nom | cut -c1 | egrep -q [0-9] || echo $Nom | grep -q '\$' || echo $Nom | grep -q '\*' || echo $Nom | grep -q '\?' || echo $Nom | grep -q '\[' || echo $Nom | grep -q '\]' || echo $Nom | grep -q '\""' || echo $Nom | grep -q '\/' || echo $Nom | grep -q '\&' || echo $Nom | grep -q '\;' || echo $Nom | grep -q '\^' || echo $Nom | egrep -q "\(" || echo $Nom | egrep -q "\)" || echo $Nom | egrep -q '<' || echo $Nom | egrep -q '>' || echo $Nom | egrep -q "\\|" || echo $Nom | egrep -q "'" || echo $Nom | egrep -q " "
then
return 0
else
return 1
fi
}
#Valida que el usuario o grupo ingresado existan previamente
ValidarExistencia() {
if cut -f1 -d: $1 | egrep -w -q $2 && [ -n $2 ]
then
return 0
else
return 1
fi
}
#Valida que el usuario ingresado no pertenezca al grupo ingresado
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
#Inicia el bucle que permite operar con las opciones
while [ "$OP" != 0 ]
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "1) Crear un grupo"
echo "2) Eliminar un grupo"
echo "3) Asignar grupo secundario a un usuario"
echo "4) Eliminar usuario de grupo secundario"
echo "0) Regresar"
read -p "Ingrese una opcion: " OP
case $OP in
1) read -p "Ingrese el nombre del grupo a crear: " Nom
#Valida que nombre ingresado no corresponda con el de un grupo ya existente y llama a la funcion ValidarNombre
if cut -f1 -d: /etc/group | egrep -q -w $Nom || ValidarNombre $Nom
then
echo "El nombre de grupo ingresado no es valido"
else
#Crea un grupo con el nombre ingresado
sudo groupadd $Nom
echo "Grupo creado con exito"
fi
sleep 2;;
2) read -p "Ingrese el nombre del grupo a eliminar: " Nom
#Valida que el grypo a eliminar exista llamando a la funcion ValidarExistencia pasandole el nombre ingresado
if ValidarExistencia /etc/group $Nom
then
#Valida que el grupo a eliminar no tenga miembros
if [[ -n `egrep -w $Nom:x:[0-9]*:* /etc/group | cut -f4 -d:` ]]
then
echo "El grupo no puede ser eliminado debido a que aun cuenta con participantes"
else
#Elimina el grupo
sudo groupdel $Nom
echo "Grupo eliminado con exito"
fi
else
echo "El nombre de grupo ingresado no se corresponde con uno del sistema o es vacio"
fi
sleep 2;;
3) read -p "Ingrese el nombre del usuario a ingresar en un grupo: " Nom
#Valida que el usuario ingresado exista llamando a la funcion ValidarExistencia con el nombre ingresado
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese el nombre del grupo: " Grp
#Valida que el grupo ingresado exista llamando a la funcion ValidarExistencia con el grupo ingresado
if ValidarExistencia /etc/group $Grp
then
#Valida que el usuario ingresado no perteneciera previamente al grupo integrado llamando a la funcion ValidarPertenenciaGrupo
if ValidarPertenenciaGrupo $Grp $Nom
then
#Agregar el usuario al grupo
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
4) read -p "Ingrese el nombre del usuario a eliminar del grupo: " Nom
#Valida que el usuario ingresado exista llamando a la funcion ValidarExistencia con el nombre ingresado
if ValidarExistencia /etc/passwd $Nom
then
read -p "Ingrese el nombre del grupo al que pertenece: " Grp
#Valida que el grupo ingresado exista llamando a la funcion ValidarExistencia con el grupo ingresado
if ValidarExistencia /etc/group $Grp
then
#Valida que el usuario ingresado no perteneciera previamente al grupo integrado llamando a la funcion ValidarPertenenciaGrupo
if ValidarPertenenciaGrupo $Grp $Nom
then
echo "El usuario ingresado no pertenece al grupo ingresado"
else
#Elimina al usuario del grupo
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
0)echo Adios;;
*) echo "La opcion ingresada no es valida"
sleep 2;;
esac
done
