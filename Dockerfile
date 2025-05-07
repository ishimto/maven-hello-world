FROM maven:3.9.2 AS buildjar
COPY myapp/ .
RUN mvn compile
RUN mvn package


FROM amazoncorretto:17.0.7-alpine AS runapp
RUN adduser -D -h /home/nonroot nonroot
USER nonroot
WORKDIR /home/nonroot/
COPY --from=buildjar target/*.jar .
CMD java -jar *.jar && sleep 300

