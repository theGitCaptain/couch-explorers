FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app

# Copying only the necessary files for cache efficiency
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Lightweight runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app

COPY --from=builder /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/imagegenerator.jar

ENV SQS_QUEUE_URL=""

ENTRYPOINT ["java", "-jar", "/app/imagegenerator.jar"]