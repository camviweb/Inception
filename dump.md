## Docker installation
sudo apt install docker.io  
sudo apt install docker-compose  
sudo systemctl enable --now docker  
sudo usermod -aG docker $USER  

## Docker commands
docker build -t <image_name> .
-  build an image from a Dockerfile
- -t to give a name to the image
- . : the context, the folder with the Dockerfile

docker run --rm --name <container_name> <image_name>
- create and start a container from <image_name>
- -d to run in the background
- --rm to delete the container when it stops
- --env-file <env_file_name>

docker exec -it <container_name> <command>
- execute a new command in <container_name>
- -it to get an interactive shell

docker exec -it test mariadb

docker image prune
docker rmi <image_name>
