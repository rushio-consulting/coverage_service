FROM cirrusci/flutter

VOLUME /coverage-project

# ADD current project into /service directory in the image
# Omit the test directory
COPY pubspec.yaml /service/
COPY bin /service/bin
COPY lib /service/lib
COPY protos /service/protos

COPY launch.sh /service/launch.sh
COPY main.sh /service/main.sh
COPY server.sh /service/server.sh

USER root

RUN apt-get update && \
    apt-get install -y uuid-runtime && \
    chmod +x /service/launch.sh && \
    chmod +x /service/main.sh && \
    chmod +x /service/server.sh && \
    chown -R cirrus:cirrus /service

USER cirrus
WORKDIR /service

RUN pub global activate coverage && \
    pub get

# Define default command
CMD ["/service/launch.sh"]
