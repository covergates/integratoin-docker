FROM gitea/gitea:latest

COPY conf/app.ini /data/gitea/conf/app.ini
COPY entrypoint.sh /bin/entrypoint.sh
ENV USER=root
ENTRYPOINT ["bash", "/bin/entrypoint.sh"]
