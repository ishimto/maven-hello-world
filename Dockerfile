FROM openjdk:7-jre-alpine
COPY myapp/*.jar .
CMD java -jar *.jar
