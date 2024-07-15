plugins {
  id("java")
  id("org.springframework.boot") version "3.0.6"
  id("io.spring.dependency-management") version "1.1.0"
}

sourceSets {
  main {
    java.setSrcDirs(setOf("."))
  }
}

repositories {
  mavenCentral()
}

dependencies {
  implementation("org.springframework.boot:spring-boot-starter-web")
  implementation("software.amazon.opentelemetry:aws-opentelemetry-agent:1.31.0")
  runtimeOnly("io.opentelemetry.instrumentation:opentelemetry-logback-mdc-1.0:1.31.0-alpha")
}