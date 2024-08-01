FROM public.ecr.aws/docker/library/gradle:jdk17 AS builder

WORKDIR /app
COPY *.java .
COPY *.jar .
COPY build.gradle.kts .

RUN ["gradle", "assemble"]

FROM gcr.io/distroless/java17-debian11:latest

WORKDIR /app
COPY --from=builder /app/build/libs/ ./build/libs/
COPY logback.xml ./logback.xml

ADD https://github.com/aws-observability/aws-otel-java-instrumentation/releases/download/v1.32.3/aws-opentelemetry-agent.jar ./aws-opentelemetry-agent.jar

CMD ["/app/build/libs/app.jar"]