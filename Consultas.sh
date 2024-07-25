#!/bin/bash
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
echo "1) Ver lista de usuarios"
echo "2) Ver lista de grupos con participantes"
echo "0) Salir"
read -p "Ingrese una opcion: " OP
case $OP in
1)echo "Usuario / Descripcion"
egrep -w home /etc/passwd | cut -f1,5 -d: | tr : " "
sleep 5;;
2)echo "Grupo / Integrantes"
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
