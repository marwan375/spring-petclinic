FROM maven:3.9.7-amazoncorretto-17 AS build

WORKDIR /app

COPY . .

RUN ./mvnw package -DskipTest -Dspring-boot.run.profiles=postgres

FROM amazoncorretto:17 AS run

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
