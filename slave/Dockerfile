FROM postgres:11.6
ENV GOSU_VERSION 1.10
ADD ./gosu /usr/bin/
RUN chmod +x /usr/bin/gosu
RUN apt-get update && apt-get install -y iputils-ping
COPY ./scripts ./scripts
RUN find ./scripts -type f -exec chmod +x {} \;
ENTRYPOINT ["/scripts/slave-entrypoint.sh"]
CMD ["gosu", "postgres", "postgres"]
