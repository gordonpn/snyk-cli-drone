FROM node:14-buster-slim
LABEL maintainer="contact@gordon-pn.com"
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    gnupg-agent \
    software-properties-common && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN npm install --global snyk
WORKDIR /home/node
ENV HOME /home/node
