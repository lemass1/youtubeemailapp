# ------------------ FRONTEND BUILD ------------------
FROM node:18-alpine AS frontend-build

# Set working directory inside container
WORKDIR /app/frontend

# Copy only package.json and package-lock.json to leverage Docker cache
COPY frontend/package*.json ./

# Install frontend dependencies
RUN npm install --legacy-peer-deps

# Copy rest of frontend source code
COPY frontend/ ./

# Build React app
RUN npm run build

# ------------------ BACKEND BUILD ------------------
FROM maven:3.9.11-eclipse-temurin-17 AS backend-build

WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw pom.xml ./
COPY .mvn .mvn

# Copy backend source code
COPY src ./src

# Copy React build output into Spring Boot static resources
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static

# Package Spring Boot application (skip tests)
RUN ./mvnw clean package -DskipTests -Dskip.npm=true

# ------------------ FINAL IMAGE ------------------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the Spring Boot jar from backend-build stage
COPY --from=backend-build /app/target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar

# Expose port 8080
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "youtubeemailapp.jar"]
