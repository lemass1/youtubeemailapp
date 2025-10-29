# --------- Stage 1: Build Frontend ---------
FROM node:20 AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# --------- Stage 2: Build Backend ---------
FROM maven:3.9.3-eclipse-temurin-17 AS backend-build
WORKDIR /app/backend
COPY backend/pom.xml ./
COPY backend/src ./src
# Copy built frontend into backend resources
COPY --from=frontend-build /app/frontend/build ./src/main/resources/static
RUN mvn clean package -DskipTests

# --------- Stage 3: Run App ---------
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=backend-build /app/backend/target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","youtubeemailapp.jar"]
