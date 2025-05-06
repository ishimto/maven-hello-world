FROM openjdk:7-jre-alpine
COPY myapp/target/*.jar .
CMD java -jar *.jar
