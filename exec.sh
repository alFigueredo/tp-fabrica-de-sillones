#!/bin/bash

source .env

EXEC="docker compose exec -it mssql /opt/mssql-tools18/bin/sqlcmd -S $HOST -d $DB -U $USERNAME -P $MSSQL_SA_PASSWORD -No"

echo
if [[ -z $1 ]]; then
	$EXEC
elif [[ -f $1 ]]; then
	# LINE=$(cat $1 | xargs -0)
	# echo "$LINE"
	LINE=$(cat $1)
	echo
	$EXEC -Q "$LINE"
else
	$EXEC -Q "$1"
fi
echo
