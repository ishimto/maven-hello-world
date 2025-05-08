FROM maven:3.9.2 AS build
COPY myapp/pom.xml ./pom.xml
RUN mvn dependency:go-offline

FROM build AS test
COPY myapp/src/test ./src/test
RUN mvn surefire:test

FROM test AS compile
COPY myapp/src/main ./src/main
RUN mvn compiler:compile
RUN mvn build-helper:parse-version versions:set -DnewVersion='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}'

FROM compile AS package
RUN mvn package -DskipTests

FROM amazoncorretto:17.0.7-alpine AS runapp
RUN adduser -D -h /home/nonroot nonroot
USER nonroot
WORKDIR /home/nonroot/
RUN mkdir shared
COPY --from=package target/*.jar .
COPY --from=package pom.xml .
CMD java -jar *.jar && sleep 300

