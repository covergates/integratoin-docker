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

/usr/bin/entrypoint&
wait-for-url "http://127.0.0.1:3000"
/app/gitea/gitea admin create-user --username=gitea --password=gitea --email=gitea@gitea.com --admin
fg
