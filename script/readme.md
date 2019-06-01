## After Vagrant up run successfully. Run following commands

## SSH on Kubernetes 

```sh
vagrant ssh <kubernetes_name>
```
**Example:** vagrant ssh k8s-1

## Run as SuperUser

Became super user to run:-
```sh
sudo su -
```
**NOTE:** Please became superuser before running any `kubectl` command.

## Clone the repo to run application on container

```sh
git clone https://github.com/jaibapna/node-express-mongoose.git
```
**NOTE:** To install git on container run `apt install git`.

## To deploy application on container. go to folder location

```sh
cd /node-express-mongoose-demo/k8s/
```

## Deploy our yaml file on kubernetes cluster

```sh
kubectl apply -f mongo.yaml
kubectl apply -f nodejsapp.yaml
```
**NOTE:** First deploy mongo.yaml to set endpoint otherwise it throw error `imagepullbackoff`.

## To get info of containers

```sh
kubectl get pods
```

## To get logs of containers

```sh
kubectl logs <container_name>
```
