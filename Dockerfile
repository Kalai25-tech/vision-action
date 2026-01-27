# -------- Build stage --------
FROM eclipse-temurin:11-jdk AS BUILD_IMAGE

RUN apt-get update && apt-get install -y maven

WORKDIR /vprofile-project
COPY . .
RUN mvn clean package -DskipTests


# -------- Runtime stage --------
FROM tomcat:9.0-jdk11-temurin

LABEL "Project"="Visionops"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE /vprofile-project/target/vprofile-v2.war \
  /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
