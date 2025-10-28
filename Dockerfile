# -------------------------
# Stage 1: Build frontend
# -------------------------
FROM node:20-alpine AS frontend-build

# Set working directory
WORKDIR /app/frontend

# Copy only frontend files to leverage Docker cache
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy all frontend source files
COPY frontend/. .

# Build React app
RUN npm run build

# -------------------------
# Stage 2: Build backend
# -------------------------
FROM maven:3.9.2-eclipse-temurin-17 AS backend-build

# Set working directory
WORKDIR /app

# Copy backend pom.xml
COPY pom.xml ./

# Copy backend source code
COPY src ./src

# Copy React build from frontend stage into backend static folder
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static

# Build Spring Boot JAR
RUN mvn clean package -DskipTests

# -------------------------
# Stage 3: Runtime
# -------------------------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy JAR from backend build stage
COPY --from=backend-build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
