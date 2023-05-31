#!/bin/bash

DATE=`date +"%d-%m-%Y_%H-%M"`
DIR="/data/data/com.termux/files/home/storage/shared/Termux/Backups"
LOGS_FILE="termux-bckp_"$DATE".log"
BCKP_FILE="termux-bckp_"$DATE".bckp.tar.xz"

logger(){
	echo -e $1 >> $DIR"/"$LOGS_FILE
}

check_command(){
	if [ $1 -eq 0 ]; then
		logger "$(date)       \t\tEjecucion OK"
	else
		logger "$(date)       \t\tERROR: Ejecucion NO OK"
		logger "$(date)   \tFinalizando script debido a ERROR"

		mv $DIR"/"$LOGS_FILE $DIR"/ERROR_"$LOGS_FILE

		echo "El backup ha fallado, revisa ERROR_"$LOGS_FILE"para mas informacion" | termux-notification --title "ERROR: Termux backup" --type media --icon warning

		exit 1
	fi
}

logger "$(date)   \tIniciando script"
logger "$(date)     \t\tEliminando antigua copia del directorio home /data/data/com.termux/filesusr/backup"

rm -rf /data/data/com.termux/files/usr/backup/home
check_command "$?"
sleep 1

logger "$(date)     \t\tCreando nueva copia del directorio home /data/data/com.termux/filesusr/backup/home"

cp -r /data/data/com.termux/files/home /data/data/com.termux/files/usr/backup
check_command "$?"
sleep 1

logger "$(date)     \t\tRealizando backup $BCKP_FILE"

termux-backup --force --ignore-read-failure $DIR"/"$BCKP_FILE
check_command "$?"
sleep 1

#ls -lh $DIR"/"$BCKP_FILE | egrep -o "[0-9]{1,4}[M,G]"
logger "$(date)       \t\tCopia de seguridad terminada, la copia ocupa $(ls -lh $DIR"/"$BCKP_FILE | grep -Eo '[0-9]{1,4}[M,G]')"
logger "$(date)       \t\tBuscando copias de seguridad antiguas (+7 dias)"

OLD_FILE=`find $DIR"/"termux-bckp_*.bckp.tar.xz -mtime +7`
if [[ -z $OLD_FILE ]];
then
	logger "$(date)          \t\t\tNo hay copias de seguridad antiguas"
else
	logger "$(date)          \t\t\tSe han encontrado las siguientes copias de seguridad antiguas\n$OLD_FILE"
	logger "$(date)          \t\t\tEliminando..."

	find $DIR"/"termux-bckp_*.bckp.tar.xz -mtime +7 -exec rm {} \;
fi


logger "$(date)   \tFinalizando script"

echo "El backup se ha realizado exitosamente" | termux-notification --title "Termux backup" --type media --icon done

exit 0
