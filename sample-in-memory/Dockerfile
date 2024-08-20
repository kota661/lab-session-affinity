FROM gradle:jdk21 AS build
COPY --chown=gradle:gradle ./ /home/gradle/src/
WORKDIR /home/gradle/src
RUN gradle build --no-daemon 

FROM openjdk:21
EXPOSE 8080
WORKDIR /app
COPY --from=build /home/gradle/src/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
