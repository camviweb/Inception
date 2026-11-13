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