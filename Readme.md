# Container based CI
This is a setup to get Jenkins running in your Minikube with a bunch of plugins including Kubernetes Plugin to deploy slaves.

## Minikube Quick Setup
If you know what you are doing, copy all this and it should be running:
```sh
kubectl create namespace jenkins
kubectl create -f jenkins-ui-service.yaml
kubectl create -f jenkins-slaves-service.yaml
kubectl create -f jenkins-persistent-volume.yaml
minikube ssh "sudo chmod 777 /var/run/docker.sock"
minikube ssh "sudo mkdir -p /data/jenkins-data && sudo chmod 777 /data/jenkins-data"
kubectl create -f jenkins-master-deployment.yaml
```

## Setup for Minikube
Once you have minikube running, create namespace Jenkins, start your services for slaves and to get into Jenkins UI:
```sh
kubectl create namespace jenkins
kubectl create -f jenkins-ui-service.yaml
kubectl create -f jenkins-slaves-service.yaml
```
This creates a volume to minikube so your Jenkins data won't vanish after shutting down minikube:
```sh
kubectl create -f jenkins-persistent-volume.yaml
```
Give access to docker.socket so you can deploy slaves in Kubernetes:
```sh
minikube ssh "sudo chmod 777 /var/run/docker.sock"
```
Create folder before Jenkins deployment to prevent errors from Jenkins not getting access to volume and give Jenkins access to persistent volume. If the access errors appear, try giving access again:
```sh
minikube ssh "sudo mkdir -p /data/jenkins-data && sudo chmod 777 /data/jenkins-data"
```
This will create Jenkins deployment and pod with container:
```sh
kubectl create -f jenkins-master-deployment.yaml
```

## Getting access to Jenkins
Use this kubectl command to get NodePort to get access to Jenkins UI. Alternatively, use 'minikube dashboard' to get NodePort from Jenkins UI Service:
```sh
kubectl describe services jenkins-ui -n jenkins
```
For example
```sh
NodePort:               <unset> 32375/TCP
```
Also, check the IP-address of the Minikube machine:
```sh
minikube ssh "ifconfig"
```
Then navigate to Jenkins with Minikube IP-address and input your own NodePort from Jenkins UI Service to port section.
```sh
192.168.99.100:32375
```
When you are in Jenkins install wizard, you can get Administrator password from the Jenkins pod. First, list all pods from Jenkins namespace:
```sh
kubectl get pods -n jenkins
```
Use whole Jenkins podname to access logs and find the password from output:
```sh
kubectl logs jenkins-something-unique -n jenkins
```

## Jenkins setup for Kubernetes
- Install Kubernetes Plugin and go to "Manage Jenkins -> Configure System".
- \# of executors should be 0 when using Kubernetes slaves.
- Add new cloud of type: Kubernetes
- Name: kubernetes
- Kubernetes URL: https://kubernetes.default.svc.cluster.local
- Kubernetes namespace: jenkins
- Select Jenkins from add next to credentials
  - Select Kubernetes service account as kind
  - Add
  - Select newly generated choise as credentials
- Jenkins URL: http://jenkins-ui.jenkins.svc.cluster.local:8080
- Jenkins Tunnel: jenkins-discovery.jenkins.svc.cluster.local:50000

## Upgrading Jenkins
Change container image to newer version in jenkins-master-deployment.yaml.
Then apply it:
```sh
kubectl -n jenkins apply -f jenkins-master-deployment.yaml
```
Newer version should be up running in couple of minutes.

## Pipeline example
Below is an example, how to use Kubernetes slaves in pipeline.
```sh
podTemplate(label: 'somepod', 
	containers: [
		containerTemplate(name: 'docker', image: 'ptcos/ci-jenkins-slave:test-1.00', alwaysPullImage: true, ttyEnabled: true, command: '/bin/sh -c', args: 'cat')
	], volumes: [hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')]
) {
    node('somepod') {
		container('docker') {
		sh """
		docker version
		docker images
		"""
		}
	}
}
```