FROM maven:3.6-jdk-8-alpine AS build

WORKDIR /app

# Bước 1: Copy pom.xml trước → tải dependencies → Docker CACHE layer này
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Bước 2: Copy source code → chỉ layer này bị rebuild khi code thay đổi
COPY src ./src
RUN mvn clean package -DskipTests=true

FROM amazoncorretto:8u482-alpine3.21-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
