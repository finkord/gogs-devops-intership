#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    DO
    \$do\$
    BEGIN
       IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$POSTGRES_GOGS_USER') THEN
           CREATE USER $POSTGRES_GOGS_USER WITH PASSWORD '$POSTGRES_GOGS_PASSWORD';
       END IF;
    END
    \$do\$;

    DO
    \$do\$
    BEGIN
       IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '$POSTGRES_GOGS_DB') THEN
           CREATE DATABASE $POSTGRES_GOGS_DB OWNER $POSTGRES_GOGS_USER;
       END IF;
    END
    \$do\$;

    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_GOGS_DB TO $POSTGRES_GOGS_USER;

    DO
    \$do\$
    BEGIN
       IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$POSTGRES_OTEL_USER') THEN
           CREATE USER $POSTGRES_OTEL_USER WITH PASSWORD '$POSTGRES_OTEL_PASSWORD';
       END IF;
    END
    \$do\$;

    GRANT pg_monitor TO $POSTGRES_OTEL_USER;
EOSQL