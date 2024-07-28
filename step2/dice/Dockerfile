FROM --platform=arm64 public.ecr.aws/docker/library/gradle:jdk17 AS builder

WORKDIR /app
COPY *.java .
COPY *.jar .
COPY build.gradle.kts .

RUN ["gradle", "assemble"]

FROM --platform=arm64 gcr.io/distroless/java17-debian11:latest

WORKDIR /app
COPY --from=builder /app/build/libs/ ./build/libs/
COPY logback.xml ./logback.xml

ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.33.4/opentelemetry-javaagent.jar ./opentelemetry-javaagent.jar

CMD ["/app/build/libs/app.jar"]