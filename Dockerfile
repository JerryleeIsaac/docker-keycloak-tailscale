FROM docker.io/ubuntu:22.04

ENV KEYCLOAK_VERSION=23.0.6

RUN apt update
RUN apt install wget zip curl -y

WORKDIR /tmp

# Install jdk
RUN wget https://download.oracle.com/java/17/archive/jdk-17.0.10_linux-x64_bin.deb
RUN dpkg -i jdk-17.0.10_linux-x64_bin.deb
RUN rm jdk-17.0.10_linux-x64_bin.deb


# Install keycloak
RUN wget https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.zip
RUN unzip keycloak-${KEYCLOAK_VERSION}.zip
RUN mv keycloak-${KEYCLOAK_VERSION} /opt/keycloak

# Install tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list

RUN apt update
RUN apt install tailscale -y

WORKDIR /opt/keycloak

# Setup keycloak certificate location
RUN mkdir -p /opt/certs
ENV KC_HTTPS_CERTIFICATE_FILE=/opt/certs/cert.crt
ENV KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/certs/cert.key

COPY command.sh .

CMD ["bash", "command.sh"]
