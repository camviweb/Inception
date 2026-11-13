*This project has been created as part of the 42 curriculum by canguyen.*  

## Description
Hosting a WordPress website on a small infrastructure of 3 Docker containers (NGINX, WordPress and MariaDB), running inside a virtual machine.  
The goal is to use Docker to build, configure and connect these services together.   

## Instructions

### Compilation
```bash
make
```

## Project description

### Main design choices
- One service per container, each one running a single process in the foreground as PID 1 (e.g. `nginx -g "daemon off"`). A container only lives as long as its main process, so the service must not be daemonize.
- One volume for the WordPress database (MariaDB) and one for the WordPress files

### Virtual Machines vs Docker
A Virtual Machine simulates a whole computer, using its own kernel : it's isolated but heavy and slow to start whereas a Docker container only isolates a program and uses the kernel of its host : it's lighter and start quickly.

### Docker Network vs Host Network
With `network_mode: host` in a service, the container uses the host's network stack: there is no isolation, every port it opens is open on the host, and Docker's name resolution between containers is not available.  
A docker (bridge) network gives each container its own address and DNS name (`mariadb`, `wordpress`, `nginx`). Only ports listed under `ports:` are reachable from the host (here 443 on nginx).

### Docker Volumes vs Bind Mounts
Both give a container **persistent storage** that outlives it by mounting a directory from outside the container into its filesystem.  
A bind mount mounts an existing host directory, referenced by its absolute path, into the container. The directory belongs to the host: Docker does not track or clean it up.  
A Docker (named) volume is a storage object created and tracked by Docker (`docker volume ls`). It is referenced by name only and Docker can decide where its data lives on the host (by default `/var/lib/docker/volumes`).  

## Vocabulary
- **(Docker) container** = a running instance of an image, one or more isolated processes in which a program runs, they operate within their own user space (file system, libraries, dependencies) while sharing the host machine's kernel (so lighter than a virtual machine)  
- **(Docker) image** = a static template that contains everything necessary (files, binaries, libraries, configuration) to launch a container  

## Resources
- [Docker doc on container](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/)  
- [Docker doc on image](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/)  
- [Official image of Nginx](https://hub.docker.com/_/nginx)  
- [Official image of MariaDB](https://hub.docker.com/_/mariadb)  
- [Inception tutorial](https://inception.cluzet.fr/) : restart at Docker > Docker Compose 
- AI was used for technical explanations  
