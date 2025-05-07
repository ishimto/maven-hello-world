FROM maven:3.9.2 AS buildjar
COPY myapp/ .
RUN mvn compile
RUN mvn package


FROM openjdk:17-alpine AS runapp
COPY --from=buildjar target/*.jar .
CMD java -jar *.jar && sleep 300

