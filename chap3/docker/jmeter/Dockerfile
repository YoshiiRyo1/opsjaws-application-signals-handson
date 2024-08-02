FROM openjdk:8-slim

ENV JMETER_VERSION=5.6.3

WORKDIR /app

ADD https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.zip .
ADD https://jmeter-plugins.org/files/packages/jpgc-casutg-2.10.zip .

RUN apt-get update && apt-get install -y unzip && \
  unzip apache-jmeter-5.6.3.zip && \
  rm apache-jmeter-5.6.3.zip && \
  unzip jpgc-casutg-2.10.zip && \
  rm jpgc-casutg-2.10.zip && \
  cp -pr lib /app/apache-jmeter-5.6.3/ && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV JMETER_HOME=/app/apache-jmeter-${JMETER_VERSION}
ENV PATH=$JMETER_HOME/bin:$PATH

CMD ["jmeter", "-n", "--help"]
