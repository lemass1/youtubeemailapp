# ---------- FRONTEND BUILD ----------
FROM node:18-alpine AS frontend-build
WORKDIR ./frontend

# Copy frontend package files from repo root
COPY frontend/package*.json ./
RUN npm install --legacy-peer-deps

# Copy rest of frontend and build
COPY frontend/ ./
RUN npm run build

# ---------- BACKEND BUILD ----------
FROM maven:3.9.11-eclipse-temurin-17 AS backend-build
WORKDIR /.

# Copy Maven files
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Copy Java source code
COPY src ./src

# Copy built frontend into Spring Boot resources/static
COPY --from=frontend-build ./frontend/build ./src/main/resources/static

# Build Spring Boot jar
RUN ./mvnw clean package -DskipTests

# ---------- FINAL IMAGE ----------
FROM eclipse-temurin:17-jre
WORKDIR /.

# Copy jar from backend build
COPY --from=backend-build ./target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar

# Expose port for Render
EXPOSE 8080

# Start Spring Boot app
CMD ["java", "-jar", "youtubeemailapp.jar"]
