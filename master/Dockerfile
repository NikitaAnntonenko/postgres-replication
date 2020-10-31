FROM postgres:11.6
ENV GOSU_VERSION 1.10
ADD ./gosu /usr/bin/
RUN chmod +x /usr/bin/gosu
COPY ./scripts ./scripts
RUN find ./scripts -type f -exec chmod +x {} \;
ENTRYPOINT ["/scripts/master-entrypoint.sh"]
CMD ["gosu", "postgres", "postgres"]