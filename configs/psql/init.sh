#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    -- Create Gogs user with password
    CREATE USER $POSTGRES_GOGS_USER WITH PASSWORD '$POSTGRES_GOGS_PASSWORD';

    -- Create Gogs database owned by Gogs user
    CREATE DATABASE $POSTGRES_GOGS_DB OWNER $POSTGRES_GOGS_USER;

    -- Grant all privileges on Gogs database to Gogs user
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_GOGS_DB TO $POSTGRES_GOGS_USER;

    -- Create OpenTelemetry user with password
    CREATE USER $POSTGRES_OTEL_USER WITH PASSWORD '$POSTGRES_OTEL_PASSWORD';

    -- Grant pg_monitor role to OpenTelemetry user for monitoring permissions
    GRANT pg_monitor TO $POSTGRES_OTEL_USER;

    -- Create SonarQube user with password
    CREATE USER $SONARQUBE_SONAR_USER WITH PASSWORD '$SONARQUBE_SONAR_PASSWORD';

    -- Create SonarQube database owned by SonarQube user
    CREATE DATABASE $SONARQUBE_SONAR_DB OWNER $SONARQUBE_SONAR_USER;

    -- Grant all privileges on SonarQube database to SonarQube user
    GRANT ALL PRIVILEGES ON DATABASE $SONARQUBE_SONAR_DB TO $SONARQUBE_SONAR_USER;
EOSQL
