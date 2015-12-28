FROM nanobox/build:beta

# Remove existing engines, we don't want to test those
RUN rm -rf /opt/engines/*

# Create folders for this engine
RUN mkdir -p /engine/bin && \
    mkdir -p /engine/lib && \
    mkdir -p /engine/templates && \
    mkdir -p /tests

# Add in this engine's files
ADD bin/. /engine/bin
ADD lib/. /engine/lib
ADD templates/. /engine/templates
ADD tests/. /tests
