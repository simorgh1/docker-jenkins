FROM jenkins/jenkins:lts
LABEL maintainer="Bahram Maravandi"

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive

# Change to root user
USER root

# Used to set the docker group ID
# Set to 497 by default, which is the group ID used by AWS Linux ECS Instance
ARG DOCKER_GID=497

# Create Docker Group with GID
# Set default value of 497 if DOCKER_GID set to blank string by Docker Compose
RUN groupadd -g ${DOCKER_GID:-497} docker

# Used to control Docker and Docker Compose versions installed
ARG DOCKER_ENGINE=5:19.03.8
ARG DOCKER_COMPOSE=1.25.0

# Install base packages
RUN apt-get update -y && \
    apt-get install apt-transport-https \
    curl \
    python-dev \
    python-setuptools \
    gcc \
    make \
    libssl-dev \
    lsb-release \
    software-properties-common -y && \
    easy_install pip

# Install Docker Engine
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install docker-ce=${DOCKER_ENGINE:-5:19.03.8}~3-0~debian-stretch docker-ce-cli=${DOCKER_ENGINE:-5:19.03.8}~3-0~debian-stretch containerd.io -y && \
    usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Install Docker Compose
RUN pip install docker-compose==${DOCKER_COMPOSE:-1.25.0} && \
    pip install ansible boto boto3

# Change to jenkins user
USER jenkins

# Add Jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt