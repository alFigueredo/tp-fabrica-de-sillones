#!/bin/bash

source .env

docker compose cp gd_esquema.Schema.sql mssql:.
docker compose cp gd_esquema.Maestra.sql mssql:.
docker compose cp gd_esquema.Maestra.Table.sql mssql:.

docker compose exec -it mssql /opt/mssql-tools18/bin/sqlcmd -S $HOST -U $USERNAME -P $MSSQL_SA_PASSWORD -No -Q \
	"CREATE DATABASE $DB"

docker compose exec -it mssql /opt/mssql-tools18/bin/sqlcmd -S $HOST -U $USERNAME -P $MSSQL_SA_PASSWORD -No \
	-a 32767 -i gd_esquema.Schema.sql,gd_esquema.Maestra.sql,gd_esquema.Maestra.Table.sql

docker compose exec -it mssql /opt/mssql-tools18/bin/sqlcmd -S $HOST -U $USERNAME -P $MSSQL_SA_PASSWORD -No -Q \
	"CREATE SCHEMA $SCHEMA"
