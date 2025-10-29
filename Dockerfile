# ---------- FRONTEND BUILD ----------
FROM node:18-alpine AS frontend-build
WORKDIR /app/frontend

# Copy only dependency files first (for better caching)
COPY frontend/package*.json ./
RUN npm install --legacy-peer-deps

# Copy the rest of the frontend source and build it
COPY frontend/ ./
RUN npm run build

# ---------- BACKEND BUILD ----------
FROM maven:3.9.6-eclipse-temurin-17 AS backend-build
WORKDIR /app

# Copy only Maven descriptor first (for caching dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy backend source
COPY src ./src

# Copy frontend build output into Spring Boot static resources
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static

# Package the Spring Boot app (no tests for faster build)
RUN mvn clean package -DskipTests

# ---------- RUNTIME IMAGE ----------
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy packaged JAR from backend build
COPY --from=backend-build /app/target/*.jar app.jar

# Render dynamically provides PORT; expose for clarity
EXPOSE 8080

# Use environment variable PORT if present (Render sets this automatically)
ENV PORT=8080

# Run Spring Boot on Render-provided port
ENTRYPOINT ["java", "-jar", "app.jar"]
