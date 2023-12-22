# Stage 1: Build stage
FROM maven:3.8.3 AS build
WORKDIR /app

# Copy only the necessary files for dependency resolution
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the entire source code
COPY src ./src

# Build the application
RUN mvn package 

# Stage 2: Deployment stage
FROM tomcat:9.0.53-jdk11-openjdk-slim AS deploy

# Copy the .war file from the build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

