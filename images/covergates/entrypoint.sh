#!/usr/bin/env bash

set -m

wait-for-url() {
    echo "Testing $1"
    timeout -s TERM 45 bash -c \
    'while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
    do echo "Waiting for ${0}" && sleep 2;\
    done' ${1}
    echo "OK!"
    curl -I $1
}

wait-for-postgres() {
    echo "Testing Postgres"
    timeout -s TERM 45 bash -c \
    'while [[ "$(pg_isready -h $GATES_DB_HOST)" != "$GATES_DB_HOST:5432 - accepting connections" ]];\
    do echo "Waiting for postgres" && sleep 2;\
    done'
    echo "OK!"
}

wait-for-postgres
wait-for-url $GATES_GITEA_SERVER
GITEA_HOST=$(echo "$GATES_GITEA_SERVER" | sed 's/https\?:\/\///g')
curl -X POST "http://gitea:gitea@$GITEA_HOST/api/v1/user/applications/oauth2" \
  -H  "accept: application/json" -H  "Content-Type: application/json" \
  -d "{  \"name\": \"covergates\",  \"redirect_uris\": [    \"$GATES_SERVER_ADDR/login/gitea\"  ]}" > gitea.json
export GATES_GITEA_CLIENT_ID=$(cat gitea.json | jq -r ".client_id")
export GATES_GITEA_CLIENT_SECRET=$(cat gitea.json | jq -r ".client_secret")

cd /covergates
go run ./cmd/server
