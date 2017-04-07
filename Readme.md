# Container based CI
This is a setup to get Jenkins running in your Minikube with a bunch of plugins including Kubernetes Plugin to deploy slaves.
Config.xml and credentials.xml have preconfigured settings which you can set by getting into the container, copying settings and reloading Jenkins.
Use Dockerfile to make your image for deployment. 
## Minikube Quick Setup
If you know what you are doing, copy all this and it should be running:
```sh
kubectl create -f jenkins-ui-service.yaml
kubectl create -f jenkins-slaves-service.yaml
kubectl create -f plugins-txt.yaml
kubectl create -f jenkins-persistent-volume.yaml
kubectl create -f jenkins-master-deployment.yaml
```

## Setup for Minikube
Once you have minikube running, start your services for slaves and to get into Jenkins UI:
```sh
kubectl create namespace jenkins
kubectl create -f jenkins-ui-service.yaml
kubectl create -f jenkins-slaves-service.yaml*
```
This is for having your Jenkins plugins in Kubernetes configmap and Jenkins installs plugins from:
```sh
kubectl create -f plugins-txt.yaml
```
This creates a volume to minikube so your Jenkins data won't vanish after shutting down minikube:
```sh
kubectl create -f jenkins-persistent-volume.yaml
```
This will create Jenkins deployment and pod with container:
```sh
kubectl create -f jenkins-master-deployment.yaml
```

## Getting access to Jenkins
Use this kubectl command to get NodePort to get access to Jenkins UI. Alternatively, use 'minikube dashboard' to get NodePort from Jenkins UI Service.
```sh
kubectl describe services jenkins-ui -n jenkins
```
For example
```sh
NodePort:               <unset> 32375/TCP
```
Then navigate to Jenkins with Minikube IP-address and input your own NodePort from Jenkins UI Service to port section.
```sh
192.168.99.100:32375
```
Default username is jenkins and password is salainen2017!. You can change these later in Jenkins or customize your own Dockerfile.