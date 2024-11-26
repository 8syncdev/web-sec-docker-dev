FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    openssl \
    netcat-traditional \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /crypto