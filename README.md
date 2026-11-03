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

### Virtual Machine vs Docker
A Virtual Machine simulates a whole computer, using its own kernel : it's isolated but heavy and slow to start whereas a Docker container only isolates a program and uses the kernel of its host : it's lighter and start quickly.

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
