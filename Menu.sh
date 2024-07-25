#!/bin/bash
while [ "$OP" != 0 ]
do
echo "1) Menu de gestion de usuarios"
echo "2) Menu de gestion de grupos"
echo "3) Menu de gestion de consultas"
echo "0) Salir"
read -p "Seleccione una opcion: " OP
case $OP in
1) ./Usuarios.sh;;
2) ./Grupos.sh;;
3) ./Consultas.sh;;
0) echo "Adios";;
*) echo "La opcion ingresada no es valida"
sleep 2;;
esac
done
