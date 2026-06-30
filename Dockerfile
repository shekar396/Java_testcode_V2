# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM amazonlinux AS build

RUN yum install -y wget unzip java-17-amazon-corretto-devel

RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.16/binaries/apache-maven-3.9.16-bin.zip && \
    unzip apache-maven-3.9.16-bin.zip && \
    mv apache-maven-3.9.16 /opt/maven

WORKDIR /opt/app
COPY . .

RUN /opt/maven/bin/mvn package

# ── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM amazonlinux

RUN yum install -y wget unzip java-17-amazon-corretto-devel

RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.118/bin/apache-tomcat-9.0.118.zip && \
    unzip apache-tomcat-9.0.118.zip && \
    mv apache-tomcat-9.0.118 /opt/tomcat

COPY --from=build /opt/app/target/simple-webapp.war /opt/tomcat/webapps/

RUN chmod 755 /opt/tomcat/bin/catalina.sh

EXPOSE 8080
ENTRYPOINT ["/opt/tomcat/bin/catalina.sh", "run"]

# Build & push:
#   docker build -t dpthub9/chatbot:2.0 .
#   docker push dpthub9/chatbot:2.0
