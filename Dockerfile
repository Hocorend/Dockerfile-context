#First image
ARG alpine_version=3
FROM alpine:${alpine_version} AS tomcat-stage
LABEL authors="hocorend"

WORKDIR /hocorend
RUN touch file.txt

RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.100/bin/apache-tomcat-9.0.100.tar.gz \
    && tar -xvzf apache-tomcat-9.0.100.tar.gz \
    && rm apache-tomcat-9.0.100.tar.gz
#ADD "https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.100/bin/apache-tomcat-9.0.100.tar.gz" app/
COPY ./*.xml maven/

#ENTRYPOINT ["/hocorend/apache-tomcat-9.0.100/bin/catalina.sh", "run"]
#exec команды в entrypoint не перезаписать без --entrypoint

FROM alpine:latest
RUN apk add openjdk17
COPY --from=tomcat-stage /hocorend/apache-tomcat-9.0.100 /app/

EXPOSE 8080
ENTRYPOINT ["/app/apache-tomcat-9.0.100/bin/catalina.sh"]
CMD ["run"]
#Отличие CMD от ENTRYPOINT в том, что при запуске docker run при указание команд для контейнера мы перезапишем команды, указанные в CMD.
#Таким образом, CMD можно назвать дефолт-командами


