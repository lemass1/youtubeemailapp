# Stage 1: Build React frontend
FROM node:20 AS frontend-build

WORKDIR /app/frontend

# Copy only package files first for caching
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy all frontend source and build
COPY frontend/ ./
RUN npm run build

# Stage 2: Build Spring Boot backend
FROM maven:3.9.2-eclipse-temurin-17 AS backend-build

WORKDIR /app

# Copy pom.xml first (cache dependencies)
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copy backend source
COPY src ./src

# Copy built React frontend into Spring Boot resources
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static

# Package Spring Boot app
RUN mvn clean package -DskipTests

# Stage 3: Run the app
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app
COPY --from=backend-build /app/target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "youtubeemailapp.jar"]
