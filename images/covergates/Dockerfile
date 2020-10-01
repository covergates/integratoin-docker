FROM golang:1.14

RUN apt-get update -y
RUN apt-get install -y postgresql-client
RUN apt-get install -y jq

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT [ "bash", "/bin/entrypoint.sh" ]
