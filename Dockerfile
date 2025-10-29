# ---------- Stage 1: Build React frontend ----------
FROM node:20 AS frontend-build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run build

# ---------- Stage 2: Build Spring Boot backend ----------
FROM maven:3.9.3-eclipse-temurin-17 AS backend-build
WORKDIR /app
COPY pom.xml ./
COPY src ./src
# Copy React build output into Spring Boot's static resources
COPY --from=frontend-build /app/build ./src/main/resources/static
RUN mvn clean package -DskipTests

# ---------- Stage 3: Run the app ----------
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=backend-build /app/target/youtubeemailapp-0.0.1-SNAPSHOT.jar ./youtubeemailapp.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "youtubeemailapp.jar"]
