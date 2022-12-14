FROM openjdk:11.0.15-jdk-slim

RUN apt-get update && apt-get install -q -y \
	git \
	curl \
	jq \
	unzip
RUN mkdir /build
RUN mkdir /work

# Build Zest
WORKDIR /build
RUN git clone https://github.com/zaproxy/zest/

WORKDIR /build/zest
RUN ./gradlew build
RUN unzip ./build/distributions/*.zip
RUN cp -R zest-*/* /usr/

# Download geckodriver
WORKDIR /build
RUN ls -al
COPY geckodriver.sh .
RUN chmod 755 geckodriver.sh
RUN ./geckodriver.sh
RUN cp /build/geckodriver /usr/local/bin/geckodriver

# Clean up
WORKDIR /work 
RUN rm -rf /build
CMD ["/usr/bin/zest"]
