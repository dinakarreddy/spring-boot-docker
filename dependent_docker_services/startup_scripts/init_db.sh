#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER amsnbfc WITH PASSWORD 'amsnbfc';
    CREATE DATABASE amsnbfc;
    GRANT ALL PRIVILEGES ON DATABASE amsnbfc TO amsnbfc;

    ALTER USER amsnbfc CREATEDB;
    ALTER USER amsnbfc WITH SUPERUSER;
EOSQL
