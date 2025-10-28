# Use OpenJDK 17
FROM openjdk:17-jdk-slim

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy everything
COPY . /app

# Build the Spring Boot app
RUN mvn clean package -DskipTests

# Expose port
EXPOSE 10000

# Set environment variable for Render
ENV PORT=10000

# Run the jar
CMD ["java", "-jar", "target/youtubeemailapp-0.0.1-SNAPSHOT.jar"]
