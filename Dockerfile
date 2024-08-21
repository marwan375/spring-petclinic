# Stage 1: Build the application
FROM maven:3.9.7-amazoncorretto-17 AS builder

# Set the working directory inside the container
WORKDIR /spring-petclinic

# Copy the current directory contents into the container
COPY . .

# Package the application using Maven
RUN ./mvnw package -DskipTest -Dspring-boot.run.profiles=postgres

# Stage 2: Run the application
FROM amazoncorretto:17

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged application from the builder stage
COPY --from=builder /spring-petclinic/target/spring-petclinic-*.jar /app/spring-petclinic.jar

# Expose the port the app runs on

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=postgres
ENV POSTGRES_DB=petclinic
ENV POSTGRES_USER=petclinic
ENV POSTGRES_PASSWORD=petclinic
ENV POSTGRES_URL=jdbc:postgresql://172.19.130.46:5432/petclinic

# Run both PostgreSQL and the application
CMD ["java","-jar","/app/spring-petclinic.jar"]
