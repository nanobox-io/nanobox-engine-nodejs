FROM nanobox/build

# Remove existing engines, we don't want to test those
RUN rm -rf /opt/engines/*

# Create folders for this engine
RUN mkdir -p /opt/engines/nodejs/bin && \
    mkdir -p /opt/engines/nodejs/lib && \
    mkdir -p /opt/engines/nodejs/templates

# Add in this engine's files
ADD bin/. /opt/engines/nodejs/bin
ADD lib/. /opt/engines/nodejs/lib
ADD templates/. /opt/engines/nodejs/templates