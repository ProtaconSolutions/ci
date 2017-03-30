FROM jenkins:2.32.3

# Enable Slave -> Master Access Control
RUN mkdir -p /usr/share/jenkins/ref/secrets/ && echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch

USER root

# Docker binaries
RUN apt-get update && apt-get install -y docker.io && usermod -aG docker jenkins

# Default jenkins user
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

# Disable Jenkins install wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Install plugins from configmap
ENTRYPOINT /usr/local/bin/install-plugins.sh $(cat /var/jenkins_home/pluginit/plugins.txt) && /usr/local/bin/jenkins.sh

USER jenkins