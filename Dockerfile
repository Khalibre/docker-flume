FROM azul/zulu-openjdk:8

# Install required dependencies
RUN apt-get update && apt-get install -y wget

# Set Flume version
ENV FLUME_VERSION 1.11.0

# Set Flume home directory
ENV FLUME_HOME=/opt/flume

# Add Flume binaries to PATH
ENV PATH=$PATH:$FLUME_HOME/bin

# Set Flume agent name
ENV FLUME_AGENT_NAME: docker

# Set Flume configuration directory
ENV FLUME_CONF_DIR=$FLUME_HOME/conf

# Create a user called "flume" with home directory and non-login shell
RUN groupadd -r flume && useradd -r -u 1001 -g flume -s /usr/sbin/nologin -d $FLUME_HOME flume

# Download and extract Apache Flume
RUN wget -qO- https://dlcdn.apache.org/flume/$FLUME_VERSION/apache-flume-$FLUME_VERSION-bin.tar.gz | tar xvz -C /tmp && \
  mv /tmp/apache-flume-$FLUME_VERSION-bin $FLUME_HOME && \
  chown -R flume:flume "$FLUME_HOME"

ENV HADOOP_VERSION 3.3.6
ENV HADOOP_HOME /opt/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH

RUN wget -qO- "https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" | tar -xz -C /tmp && \
  mv "/tmp/hadoop-${HADOOP_VERSION}" "$HADOOP_HOME" && \
  chown -R flume:flume "$HADOOP_HOME"

COPY --chown=flume:flume rootfs /

# Set the user to "flume"
USER flume

# Set the working directory
WORKDIR $FLUME_HOME

# Expose the Flume agent's listening port (if required)
EXPOSE 44444

# Start Flume agent
ENTRYPOINT [ "start-flume.sh" ]
