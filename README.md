*This project has been created as part of the 42 curriculum by canguyen.*  

## Description
Hosting a WordPress website on a small infrastructure of 3 Docker containers (NGINX, WordPress and MariaDB), running inside a virtual machine.  
The goal is to use Docker (Compose) to build, configure and connect these services together.   

## Instructions
To build and start the project, run in a terminal at the root of the repository:
```bash
make # or make up
```
More details are provided for usage and set up in [USER_DOC.md](./USER_DOC.md) and [DEV_DOC.md](./DEV_DOC.md)

## Project description

### Use of Docker
Docker is used in this project to write my own Dockerfiles, hence build my own images, to then run the containers. I also used Docker Compose which is a tool of Docker to link containers together smoothly.

### Project sources
- A `Makefile` to wrap docker compose commands
- The `secrets/` folder containing the secret files, to be created during the defense because they should not appear in the git repository (my Makefile creates them)
- The `srcs/docker-compose.yml` file to define the services, network, volumes and secrets
- The `srcs/.env` file with the environment variables, also to be created during defense (my Makefile does it too)
- A folder `srcs/requirements` with one folder by service: `mariadb/`, `nginx/` and `wordpress/`.
- Each service's folder has a Dockerfile and a folder `conf/` with the configuration file fitting the service's needs
- For MariaDB and WordPress there is a `tools/` folder with the script used as entrypoint in the Dockerfile, because we need to create some data when first running them

### Main design choices
- Use of Debian for the Virtual Machine and initial images because it's a personal project and I already used this distribution for `Born2beroot` project. 
- One service per container, each one running a single process in the foreground as PID 1 (e.g. `nginx -g "daemon off;"`). A container only lives as long as its main process, so the service must not be daemonized.
- One volume for the WordPress database (MariaDB) and one for the WordPress files
- Both volumes are named and configured with `driver_opts` to store their data in `/home/canguyen/data`
- The WordPress files are downloaded at built time into `/usr/src/wordpress`, then copied once into `/var/www/html` when the container first starts.

### Virtual Machines vs Docker
A Virtual Machine simulates a whole computer, using its own kernel : it's isolated but heavy and slow to start whereas a Docker container only isolates processes and uses the kernel of its host: it's lighter and starts quickly.

### Secrets vs Environment Variables
Secrets are files managed by Docker to store confidential information: they are located on the host and mounted read-only in the container under `/run/secrets`, so they are not in the container's environment.  
Environment variables are key-value pairs. We usually store them in a `.env` file and can pass them to a container with the key `env_file` in a service. They are visible with `docker inspect <container_name>` and are in the container's environment.

### Docker Network vs Host Network
With `network_mode: host` in a service, the container uses the host's network stack: there is no isolation, every port it opens is open on the host, and Docker's name resolution between containers is not available.  
A user-defined Docker (bridge) network (declared under `networks:`) gives each container its own address and DNS name (`mariadb`, `wordpress`, `nginx`). Only ports listed under `ports:` are published on the host (here 443 on Nginx).

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
- [Official image of Nginx](https://hub.docker.com/_/nginx) for reference  
- [Official image of MariaDB](https://hub.docker.com/_/mariadb) for reference  
- [Inception tutorial](https://inception.cluzet.fr/)
- AI was used to get technical explanations (e.g. what the `i` and `t` in the Docker option `-it` stand for), to decipher some phrases of the subject and to check that my understanding of concepts is correct. 
