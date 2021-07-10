#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER amsnbfc WITH PASSWORD 'amsnbfc';
    CREATE DATABASE amsnbfc;
    GRANT ALL PRIVILEGES ON DATABASE amsnbfc TO amsnbfc;

    CREATE USER bre WITH PASSWORD 'bre';
    CREATE DATABASE bre;
    GRANT ALL PRIVILEGES ON DATABASE bre TO bre;

    CREATE USER bureau WITH PASSWORD 'bureau';
    CREATE DATABASE bureau;
    GRANT ALL PRIVILEGES ON DATABASE bureau TO bureau;

    ALTER USER amsnbfc CREATEDB;
    ALTER USER amsnbfc WITH SUPERUSER;
    ALTER USER bre WITH SUPERUSER;
    ALTER USER bureau WITH SUPERUSER;
EOSQL
