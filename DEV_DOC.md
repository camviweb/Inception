# Developer documentation

## Set up the environment from scratch

### 1. Prerequisite 1: a virtual machine
1. Download the image (.iso) of Debian Trixie
2. Create a new machine in VirtualBox using this image
3. Open it
4. Respond to the questions

### 2. Prerequisite 2: essential tools
1. Open a terminal and run:
```bash
su -
apt-get update
apt-get install sudo
usermod -aG sudo <username>
```
2. Log out and log back in to apply the change
3. Run in a terminal:
```bash
sudo apt-get install make
sudo apt-get install git
git config --global user.name "Your name"
git config --global user.email "Your email"
```

### 3. Prerequisite 3: Docker and Docker Compose
1. Run in a terminal:
```bash
sudo apt install docker.io  
sudo apt install docker-compose  
sudo systemctl enable --now docker  
sudo usermod -aG docker $USER
```
2. Log out and log back in again
3. To check, run in a terminal:
```bash
docker --version
docker compose version
```

### 4. Prerequisite 4: openssl to generate the secrets
1. Run in a terminal:
```bash
sudo apt install openssl  
```

### 5. Configure the domain name
1. Run in a terminal:
```bash
echo "127.0.0.1 <login>.42.fr" | sudo tee -a /etc/hosts
```

### 6. Clone the project
1. Make sure you have a SSH key registered for the Virtual Machine
2. Run in a terminal, in the directory you want:
```bash
git clone <repo> Inception
cd Inception
```

## Build and launch the project
1. Run:
```bash
make # or make up
```

## Relevant commands

### Container management
- To list containers in execution (`ps` for process status):  
Option `-a` to see stopped containers
```bash
docker ps -a
```
Or in the folder of the compose project (with `docker-compose.yml` file):
```bash
docker compose ps -a
```

- To run a command inside <container_name>
Option `-it` when the command is interactive (`bash` or database client like `mariadb`) to keep stdin open and allocate a terminal
```bash
docker exec -it <container_name> <command>
```
Or in the folder of the compose project with the name of the service:
```bash
docker compose exec <service_name> <command>
```

- To remove all stopped containers:
```bash
docker container prune
```

- To stop a container in execution:
```bash
docker stop <container_name>
```

- To remove a container:
```bash
docker rm <container_name>
```

### Volume management
- To list volumes:
```bash
docker volume ls
```

- To see the details of a volume:
```bash
docker volume inspect <volume_name>
```

- To remove all unused volumes:
```bash
docker volume prune
``` 

### Image management
- To list images:
```bash
docker image ls
```

- To remove all dandling images:
```bash
docker image prune
```

- To remove an image:
```
docker rmi <image_name>
```

### Used during development
- To build an image manually:
Option `-t` to give a name to the image  
`.` is the context, the folder with the Dockerfile  
Option `--build-arg <ARG_name>=<arg_value>` to give arguments at build
```bash
docker build -t <image_name> .
```

- To spawn a container from <image_name>:
Option `-d` to run in the background (no logs, terminal available)  
Option `--rm` to delete the container when it stops  
Option `--env-file <env_file_name>` to give an environment variables file  
Option `-p <host_port>:<container_port>` to expose a port
```bash
docker run --rm --name <container_name> <image_name>
```

- To check the `docker-compose.yml` file with expansion:
```bash
docker compose config
```

 - To check the syntax of the Nginx conf file -> to run in the Nginx container:
```bash
nginx -t
```

- To check the process in execution, relevant to see PID 1 (the x is to include process without shell) -> to run in a container:
```bash
ps aux
```

- To list docker networks:
```bash
docker network ls
```

- To see the details of a network:
```bash
docker network inspect <network_name>
```
