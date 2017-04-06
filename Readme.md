# Container based CI

## Setup for Minikube
Once you have minikube running, start your services for slaves and to get into Jenkins UI:
```sh
kubectl create namespace jenkins
kubectl create -f jenkins-ui-service.yaml
kubectl create -f jenkins-slaves-service.yaml*
```
This is for having your plugins in Kubernetes configmap and Jenkins installs plugins from:
```sh
kubectl create -f plugins-txt.yaml
```
This is for having your config.xml in Kubernetes configmap which will configure your Jenkins to have Kubernetes cloud ready to use (must symlink first from /var/jenkins_home/configs/config.xml to /var/jenkins_home/config.xml and then reload configuration):
```sh
kubectl create -f config-xml.yaml
```
This is for having your credentias.xml in Kubernetes configmap which will give credentials to your Jenkins Kubernetes cloud (must symlink first from /var/jenkins_home/credentials/credentials.xml to /var/jenkins_home/credentials.xml and then reload configuration):
```sh
kubectl create -f credentials-xml.yaml
```
This creates a volume to minikube so your Jenkins data won't vanish after shutting down minikube:
```sh
kubectl create -f jenkins-persistent-volume.yaml
```
This will create Jenkins deployment and pod:
```sh
kubectl create -f jenkins-master-deployment.yaml
```