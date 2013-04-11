#!/bin/bash
set -o errexit
SKRIPTIKANSIO=$(dirname "$0")

## Ulkopuoliset asetustiedostot
source "$SKRIPTIKANSIO"/varmuus_liitos.sh
POIKKEUKSET="$SKRIPTIKANSIO"/varmuus_poikkeukset.list

## Älä muokkaa
TALLETETUT="$MOUNTPOINT"/varmuuskopio-dummy
ARKISTOITU="$MOUNTPOINT"/varmuuskopio-$(date +%F--%H%M)
LOGITMP=/tmp/varmuuskopioidut.log

## Muokattava lista
SIIRRETTAVAT=(
/etc/
/home/kansio/
)

## rsyncin parametrit
OPTS=(
--human-readable
--archive
--hard-links
--numeric-ids
--delete-excluded
--exclude-from="$POIKKEUKSET"
--log-file="$LOGITMP"
)
#--verbose

mounttaa

echo Siirretään tiedostoja
for i in "${SIIRRETTAVAT[@]}"; do
	#[[ ! -d "$TALLETETUT"$i ]] &&  mkdir -p "$TALLETETUT"$i
	mkdir -p "$TALLETETUT"$i
	rsync "${OPTS[@]}" $i "$TALLETETUT"$i
done

echo Arkistoidaan tiedostot
cp -al "$TALLETETUT" "$ARKISTOITU"
mv "$LOGITMP" "$ARKISTOITU"/

irrottaa
