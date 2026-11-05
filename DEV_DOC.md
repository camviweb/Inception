# Developer documentation

## Relevant commands

### To manage the containers
```
docker ps -a
```
Lists containers in execution (ps for process status)  
Option -a to see stopped containers

```
docker container prune
```
Removes all stopped containers

```
docker stop <container_name>
```
Stops a container in execution

```
docker rm <container_name>
```
Removes a container

### To manage the volumes

### To manage the images
```
docker image ls
```
Lists images

```
docker image prune
```
Removes dangling images

```
docker rmi <image_name>
```
Removes <image_name>