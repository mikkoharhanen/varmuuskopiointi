#!/bin/bash
set -o errexit

# Muuta arvot
SALAUSAVAIN="/home/polku/avain"
LAITE="/dev/disk/by-uuid/UUID"

MOUNTPOINT="/mnt/ulkoboksi"
ELAITE="eulkoboksi"

mounttaa()
{
	[[ ! -e /dev/mapper/"$ELAITE" ]] && cryptsetup --key-file "$SALAUSAVAIN" luksOpen "$LAITE" "$ELAITE"

	if [[ ! -d "$MOUNTPOINT" ]]; then
		echo "Luodaan puuttuva liittämiskansio"
		mkdir "$MOUNTPOINT"
	fi

	echo "Liitetään levy"
	mount /dev/mapper/"$ELAITE" "$MOUNTPOINT"
}

irrottaa()
{
	echo "Irrotetaan levy"
	umount "$MOUNTPOINT"
	cryptsetup luksClose "$EDEVICE"
	rmdir "$MOUNTPOINT"
}

#mounttaa
#irrottaa
