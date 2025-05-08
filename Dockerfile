FROM maven:3.9.2 AS buildjar

# This stage layers breaked and not runs the all up to package immidietly,
# in order to use the last build cache that pulled in CI/CD pipeline to make this build incremental.
COPY myapp/pom.xml .
RUN mvn dependency:copy-dependencies
COPY myapp/src/test .
RUN mvn surefire:test
COPY myapp/src/main .
RUN mvn compiler:compile
RUN mvn build-helper:parse-version versions:set -DnewVersion='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}'
RUN mvn jar:jar


FROM amazoncorretto:17.0.7-alpine AS runapp
RUN adduser -D -h /home/nonroot nonroot
USER nonroot
WORKDIR /home/nonroot/
RUN mkdir shared
COPY --from=buildjar target/*.jar .
COPY --from=buildjar pom.xml .
CMD java -jar *.jar && sleep 300
