FROM cirrusci/flutter

VOLUME /coverage-project

# ADD current project into /service directory in the image
# Omit the test directory
COPY pubspec.yaml /service/
COPY bin /service/bin
COPY lib /service/lib
COPY protos /service/protos

WORKDIR /service

RUN sudo chown -R cirrus:cirrus /service && \
    pub global activate coverage && \
    export PATH="$PATH":"$HOME/.pub-cache/bin" && \
    pub get

COPY launch.sh /service/launch.sh
COPY main.sh /service/main.sh
COPY server.sh /service/server.sh

RUN sudo chmod +x /service/launch.sh && \
    sudo chmod +x /service/main.sh && \
    sudo chmod +x /service/server.sh

# Define default command
CMD ["/launch.sh"]
