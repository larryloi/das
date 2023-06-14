#!/bin/bash

  FAIL_EXIT()
    {
      echo "=="
      echo "== ${1} "
      echo "=="
      echo "== Usage: bash scripts/dbmigrate-up.sh <src|dst> <up|down|to> [migration version]"
      echo "== For example: bash scripts/db-migrate.sh src up"
      echo "== For example: bash scripts/db-migrate.sh dst down"
      echo "== For example: bash scripts/db-migrate.sh dst to 201908280902"
      echo "=="
      exit 1
    }

  SET_DB_VARIABLES()
    {
      if [[ "$DB_TARGET" == "dst" ]]; then
        export SCHEMA_TABLE=${DST_SCHEMA_TABLE}
        dbuser=${DST_MYSQL_USER}
        dbname=${DST_MYSQL_DATABASE}
        dbport=${DST_MYSQL_PORT}
        dbpasswd=${DST_MYSQL_PASSWORD}
        dbhost=${DST_MYSQL_HOST}
        schema_table=${DST_SCHEMA_TABLE}
        dbversion=${DB_VERSION}
        fractional_seconds=${DST_FRACTIONAL_SECONDS}
        encoding=${DST_ENCODING}
      elif [[ "$DB_TARGET" == "src" ]]; then
        export SCHEMA_TABLE={SRC_SCHEMA_TABLE}
        dbuser=${SRC_MYSQL_USER}
        dbname=${SRC_MYSQL_DATABASE}
        dbport=${SRC_MYSQL_PORT}
        dbpasswd=${SRC_MYSQL_PASSWORD}
        dbhost=${SRC_MYSQL_HOST}
        schema_table=${SRC_SCHEMA_TABLE}
        dbversion=${DB_VERSION}
        fractional_seconds=${SRC_FRACTIONAL_SECONDS}
        encoding=${SRC_ENCODING}
      fi
    }

  DB_MIGRATION()
    {
      SET_DB_VARIABLES
      if [[ $DB_ACTION == "up" ]]; then
        rake db:migrate:up MYSQL_USER=${dbuser} MYSQL_DATABASE=${dbname} MYSQL_PORT=${dbport} MYSQL_PASSWORD=${dbpasswd} MYSQL_HOST=${dbhost} SCHEMA_TABLE=${schema_table} FRACTIONAL_SECONDS=${fractional_seconds} ENCODING=${encoding}

      elif [[ $DB_ACTION == "down" ]]; then
        rake db:migrate:down MYSQL_USER=${dbuser} MYSQL_DATABASE=${dbname} MYSQL_PORT=${dbport} MYSQL_PASSWORD=${dbpasswd} MYSQL_HOST=${dbhost} SCHEMA_TABLE=${schema_table}  FRACTIONAL_SECONDS=${fractional_seconds} ENCODING=${encoding}

      elif [[ $DB_ACTION == "to" ]]; then
        rake db:migrate:to VERSION=${dbversion} MYSQL_USER=${dbuser} MYSQL_DATABASE=${dbname} MYSQL_PORT=${dbport} MYSQL_PASSWORD=${dbpasswd} MYSQL_HOST=${dbhost} SCHEMA_TABLE=${schema_table} FRACTIONAL_SECONDS=${fractional_seconds} ENCODING=${encoding}

      fi
    }

#============================
# Main
#=============================
#. $RVM_PATH/scripts/rvm
export DB_TARGET=$1
export DB_ACTION=$2
export DB_VERSION=$3
export MIGRATION_PATH=${MIGRATION_BASE}/$DB_TARGET
#echo $DB_TARGET; echo $DB_ACTION; echo $DB_VERSION

  if [[ -z "$DB_TARGET" ]] || [[ -z "$DB_ACTION" ]]; then
     FAIL_EXIT "Missing parameters. "

  elif [[ "$DB_TARGET" != "dst" ]] && [[ "$DB_TARGET" != "src" ]]; then
     FAIL_EXIT "Incorrect db target parameters."

  elif [[ "$DB_ACTION" != "up" ]] && [[ "$DB_ACTION" != "down" ]] && [[ "$DB_ACTION" != "to" ]]; then
     FAIL_EXIT "Incorrect action parameters."

  elif [[ "$DB_ACTION" == "to" ]] && [[ -z "$DB_VERSION" ]]; then
     FAIL_EXIT "Missing db migration version parameters."

  else
     DB_MIGRATION
  fi
