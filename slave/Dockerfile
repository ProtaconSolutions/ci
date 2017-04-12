FROM jenkinsci/jnlp-slave

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.11.0
ENV DOCKER_HOME /usr/bin/docker
ENV DOCKER_HOST unix:///var/run/docker.sock

USER root

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o ${DOCKER_HOME} \
    && chmod +x ${DOCKER_HOME}

RUN groupadd docker
RUN usermod -g docker jenkins

# kubectl, gcloud
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-123.0.0-linux-x86_64.tar.gz | tar zx -C /opt/ && \
   /opt/google-cloud-sdk/install.sh --quiet --usage-reporting false --command-completion false --path-update false --additional-components kubectl && \
   /opt/google-cloud-sdk/bin/gcloud components update --quiet && \
   ln -s /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud && \
   ln -s /opt/google-cloud-sdk/bin/kubectl /usr/bin/kubectl && \
   ln -s /opt/google-cloud-sdk/bin/git-credential-gcloud.sh /usr/bin/git-credential-gcloud.sh

USER jenkins