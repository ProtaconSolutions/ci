FROM jenkins:2.32.2

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY ./config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY ./config/default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

USER root

ENV DOCKER_VERSION=1.13.1 \
    DOCKER_COMPOSE_VERSION=1.6.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-engine=$DOCKER_VERSION* \
    && rm -rf /var/lib/apt/lists/* \
    && curl -o /bin/docker-compose -SL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 \
    && chmod +x /bin/docker-compose