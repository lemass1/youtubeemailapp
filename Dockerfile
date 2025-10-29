# ---------- FRONTEND BUILD ----------
FROM node:18-alpine AS frontend-build
WORKDIR /app/frontend

# Copy frontend package.json first
COPY frontend/package*.json ./
RUN npm install --legacy-peer-deps

# Copy frontend source and build
COPY frontend/ ./
RUN npm run build

# ---------- BACKEND BUILD ----------
FROM maven:3.9.11-eclipse-temurin-17 AS backend-build
WORKDIR /app

# Copy Maven wrapper and pom
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Copy Java sources
COPY src ./src

# Copy frontend build into Spring Boot static
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static

# Build Spring Boot jar
RUN ./mvnw clean package -DskipTests

# ---------- FINAL IMAGE ----------
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=backend-build /app/target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar
EXPOSE 8080
CMD ["java", "-jar", "youtubeemailapp.jar"]
