# Build stage
FROM maven:3.9.7-amazoncorretto-17 AS build

WORKDIR /app

# Copy the project files to the container
COPY . .

# Build the application and create a jar, skipping tests
RUN ./mvnw package -DskipTests --no-transfer-progress

# Run stage
FROM amazoncorretto:17 AS run

WORKDIR /app

# Copy the jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application's port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
