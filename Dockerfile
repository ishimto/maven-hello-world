FROM maven:3.9.2 AS buildjar
COPY myapp/ .
RUN mvn build-helper:parse-version versions:set -DnewVersion='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}'
RUN mvn compile
RUN mvn package


FROM amazoncorretto:17.0.7-alpine AS runapp
RUN adduser -D -h /home/nonroot nonroot
USER nonroot
WORKDIR /home/nonroot/
RUN mkdir shared
COPY --from=buildjar target/*.jar .
COPY --from=buildjar pom.xml .
CMD java -jar *.jar && sleep 300
