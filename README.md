# Simple Web Application v2

A Java Servlet + JSP web application packaged as a WAR file, served by **Apache Tomcat 9**, containerised with **Docker** (multi-stage build on Amazon Linux), and deployable to **Kubernetes**.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Maven POM Details](#maven-pom-details)
5. [Build Artifact](#build-artifact)
6. [Application Endpoints](#application-endpoints)
7. [Docker — Build & Run](#docker--build--run)
8. [Kubernetes Deployment](#kubernetes-deployment)
9. [Accessing the Application from the Outside World](#accessing-the-application-from-the-outside-world)

---

## Project Overview

| Field        | Value                      |
|--------------|----------------------------|
| App Name     | Simple Web Application v2  |
| Group ID     | `com.example`              |
| Artifact ID  | `simple-webapp`            |
| Version      | `2.0`                      |
| Packaging    | `WAR`                      |
| Java Version | 17 (Amazon Corretto)       |
| Servlet API  | Jakarta Servlet 6.0        |
| Web Server   | Apache Tomcat 9.0.118      |

---

## Technology Stack

| Layer         | Technology                          | Version   |
|---------------|-------------------------------------|-----------|
| Language      | Java                                | 17        |
| Servlet API   | Jakarta Servlet API                 | 6.0.0     |
| Build Tool    | Apache Maven                        | 3.9.16    |
| Web Server    | Apache Tomcat                       | 9.0.118   |
| Base OS Image | Amazon Linux (Docker)               | latest    |
| Container     | Docker (multi-stage)                | -         |
| Orchestration | Kubernetes (Pod + Service)          | -         |

---

## Project Structure

```
Java_testcode-v2/
├── Dockerfile                        # Multi-stage Docker build
├── pom.xml                           # Maven project descriptor
├── K8s-MANIFESTS/
│   ├── pod.YAML                      # Kubernetes Pod definition
│   ├── service.YAML                  # Kubernetes NodePort Service
│   └── loadbalancer.YAML             # Kubernetes LoadBalancer Service
└── src/
    └── main/
        ├── java/
        │   └── com/example/
        │       └── HelloServlet.java  # Servlet mapped to /hello
        └── webapp/
            ├── index.jsp             # Welcome/landing page
            └── WEB-INF/
                └── web.xml           # Deployment descriptor (Jakarta EE 6.0)
```

---

## Maven POM Details

File: `pom.xml`

### Coordinates

```xml
<groupId>com.example</groupId>
<artifactId>simple-webapp</artifactId>
<version>2.0</version>
<packaging>war</packaging>
```

### Key Properties

| Property                         | Value   |
|----------------------------------|---------|
| `java.version`                   | `17`    |
| `maven.compiler.source`          | `17`    |
| `maven.compiler.target`          | `17`    |
| `project.build.sourceEncoding`   | `UTF-8` |
| `jakarta.servlet.version`        | `6.0.0` |

### Dependencies

| Dependency                   | Version | Scope      | Notes                                  |
|------------------------------|---------|------------|----------------------------------------|
| `jakarta.servlet-api`        | 6.0.0   | `provided` | Supplied by Tomcat at runtime; not bundled in WAR |

### Build Plugins

| Plugin                       | Version | Purpose                                  |
|------------------------------|---------|------------------------------------------|
| `maven-compiler-plugin`      | 3.13.0  | Compiles Java 17 source files            |
| `maven-war-plugin`           | 3.4.0   | Packages the application as a WAR file; `failOnMissingWebXml=true` |

---

## Build Artifact

Running `mvn package` (or `mvn clean package`) produces:

```
target/simple-webapp.war
```

> The `<finalName>simple-webapp</finalName>` setting in `pom.xml` ensures the output file is always named `simple-webapp.war`, regardless of the artifact version.

### Build Locally (requires Java 17 + Maven)

```bash
mvn clean package
```

The WAR file will be at `target/simple-webapp.war`.

---

## Application Endpoints

The WAR is deployed at the context path `/simple-webapp` inside Tomcat.

| URL Path                                      | Description                                              |
|-----------------------------------------------|----------------------------------------------------------|
| `/simple-webapp/`                             | Landing page (index.jsp) — styled welcome card           |
| `/simple-webapp/index.jsp`                    | Same as above (explicit)                                 |
| `/simple-webapp/hello`                        | HelloServlet — greets "World" by default                 |
| `/simple-webapp/hello?name=YourName`          | HelloServlet — greets the provided name                  |

### Example full URLs (Docker local)

```
http://localhost:8080/simple-webapp/
http://localhost:8080/simple-webapp/hello
http://localhost:8080/simple-webapp/hello?name=Tom
```

---

## Docker — Build & Run

The `Dockerfile` uses a **two-stage build**:

### Stage 1 — Build (Amazon Linux + Maven)

1. Installs `wget`, `git`, `unzip`, Java 17 Amazon Corretto.
2. Downloads and installs Apache Maven 3.9.16.
3. Clones the source from GitHub: `https://github.com/shekar396/Java_testcode_V2.git`
4. Runs `mvn package` to produce `simple-webapp.war`.

### Stage 2 — Runtime (Amazon Linux + Tomcat)

1. Installs Java 17 Amazon Corretto.
2. Downloads and installs Apache Tomcat 9.0.118.
3. Copies `simple-webapp.war` from Stage 1 into Tomcat's `webapps/` directory.
4. Starts Tomcat via `catalina.sh run`.

### Build the Docker Image

```bash
docker build -t chatbots:1.0 .
```

### Run the Container

```bash
docker run --name chatbots -d -p 8080:8080 chatbots:1.0
```

| Flag              | Meaning                                      |
|-------------------|----------------------------------------------|
| `--name chatbots` | Names the container `chatbots`               |
| `-d`              | Runs in detached (background) mode           |
| `-p 8080:8080`    | Maps host port 8080 to container port 8080   |

### Useful Docker Commands

```bash
docker images          # List built images
docker ps -a           # List all containers (running and stopped)
docker logs chatbots   # View Tomcat console logs
docker stop chatbots   # Stop the container
docker rm chatbots     # Remove the container
```

### Access After Docker Run

```
http://localhost:8080/simple-webapp/
http://localhost:8080/simple-webapp/hello?name=YourName
```

---

## Kubernetes Deployment

Three manifest files are provided under `K8s-MANIFESTS/`.

### 1. Pod (`pod.YAML`)

| Field         | Value                  |
|---------------|------------------------|
| Pod Name      | `webapps-v2`           |
| Container     | `webapps-container`    |
| Image         | `dpthub9/chatbot:2.0`  |
| Labels        | `app: my-webapps`, `version: "2.0"` |

```bash
kubectl apply -f K8s-MANIFESTS/pod.YAML
```

### 2. NodePort Service (`service.YAML`)

Exposes the pod within the cluster and on each node's IP at a static port.

| Field          | Value            |
|----------------|------------------|
| Service Name   | `webapps-service`|
| Type           | `NodePort`       |
| Service Port   | `8080`           |
| Target Port    | `8080`           |
| Node Port      | `31001`          |

```bash
kubectl apply -f K8s-MANIFESTS/service.YAML
```

### 3. LoadBalancer Service (`loadbalancer.YAML`)

Provisions an external load balancer (cloud provider e.g. AWS ELB, GCP LB).

| Field          | Value                  |
|----------------|------------------------|
| Service Name   | `webapps-lb-service`   |
| Type           | `LoadBalancer`         |
| External Port  | `80`                   |
| Target Port    | `8080`                 |

```bash
kubectl apply -f K8s-MANIFESTS/loadbalancer.YAML
```

---

## Accessing the Application from the Outside World

### Option A — Docker (Local / VM)

| Scenario          | URL                                                  |
|-------------------|------------------------------------------------------|
| Local machine     | `http://localhost:8080/simple-webapp/`               |
| Remote VM / EC2   | `http://<PUBLIC_IP>:8080/simple-webapp/`             |
| Hello Servlet     | `http://<PUBLIC_IP>:8080/simple-webapp/hello?name=Tom` |

> Make sure port `8080` is open in your firewall / security group inbound rules.

---

### Option B — Kubernetes NodePort

```
http://<NODE_IP>:31001/simple-webapp/
http://<NODE_IP>:31001/simple-webapp/hello?name=Tom
```

- Replace `<NODE_IP>` with any Kubernetes worker node's external IP.
- Get the node IP:
  ```bash
  kubectl get nodes -o wide
  ```
- Port `31001` must be open in your cloud security group / firewall.

---

### Option C — Kubernetes LoadBalancer (Recommended for Production)

```
http://<EXTERNAL-IP>/simple-webapp/
http://<EXTERNAL-IP>/simple-webapp/hello?name=Tom
```

- Get the external IP assigned by your cloud provider:
  ```bash
  kubectl get svc webapps-lb-service
  ```
- The `EXTERNAL-IP` column will show the DNS name or IP once provisioned.
- Traffic on port `80` is forwarded to Tomcat on port `8080` inside the pod.

---

### Quick Reference — All Access URLs

| Method              | URL                                                       | Port |
|---------------------|-----------------------------------------------------------|------|
| Docker local        | `http://localhost:8080/simple-webapp/`                    | 8080 |
| Docker (remote VM)  | `http://<VM_PUBLIC_IP>:8080/simple-webapp/`               | 8080 |
| K8s NodePort        | `http://<NODE_IP>:31001/simple-webapp/`                   | 31001|
| K8s LoadBalancer    | `http://<EXTERNAL-IP>/simple-webapp/`                     | 80   |
| Hello Servlet       | append `/hello?name=YourName` to any base URL above       | -    |
