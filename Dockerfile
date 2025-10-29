# ---------- FRONTEND BUILD ----------
FROM node:18-alpine AS frontend-build

WORKDIR /app/frontend

# Copy package.json and package-lock.json first to leverage Docker cache
COPY frontend/package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy all frontend files
COPY frontend/ ./

# Build React app
RUN npm run build

# ---------- BACKEND BUILD ----------
FROM maven:3.9.11-eclipse-temurin-17 AS backend-build

WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw pom.xml ./
COPY .mvn .mvn

# Copy backend source
COPY src ./src

# Copy React build into Spring Boot static folder
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static

# Package Spring Boot app
RUN ./mvnw clean package -DskipTests

# ---------- FINAL IMAGE ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the Spring Boot jar
COPY --from=backend-build /app/target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar

# Expose port
EXPOSE 8080

# Run Spring Boot app
CMD ["java", "-jar", "youtubeemailapp.jar"]
