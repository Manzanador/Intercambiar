#!/bin/bash
while [ "$OP" != 0 ]
do
echo "1) Ver informacion del CPU"
echo "2) Ver uso de la memoria RAM fisica y virtual"
echo "3) Ver particiones de disco y espacio disponible"
echo "4) Ver espacio disponible en disco por directorios"
echo "5) Procesos que mas recursos consumen en el servidor"
echo "0) Salir"
read -p "Selecciona una opcion: " OP
case $OP in
1) lscpu
read -p "Presiona enter para continuar"
sleep 2;;
2) free -h
read -p "Presiona enter para continuar"
sleep 2;;
3) df -h
read -p "Presiona enter para continuar"
sleep 2;;
4) du -sh /* 2>/dev/null
read -p "Presiona enter para continuar"
sleep 2;;
5) top -b -n 1 | head -n 20
read -p "Presiona enter para continuar"
sleep 2;;
0)echo "Adios";;
*) echo "La opcion ingresada no es valida"
sleep 5;;
esac
done
