## Docker commands
docker build -t <image_name> .
-  build an image from a Dockerfile
- -t to give a name to the image
- . : the context, the folder with the Dockerfile
- --build-arg <ARG_name>=<arg_value>

docker run --rm --name <container_name> <image_name>
- create and start a container from <image_name>
- -d to run in the background
- --rm to delete the container when it stops
- --env-file <env_file_name>
- -p <host_port>:<container_port> to expose a port

docker exec -it <container_name> <command>
- execute a new command in <container_name>
- -it to get an interactive shell

docker exec -it test mariadb

## Nginx
nginx -t

## Docker Compose
docker compose config
- check the docker-compose.yml file

docker compose ps -a
- list containers of the current compose project

docker compose exec <service_name> <command>
- execute <command> in the container of <service_name>
- docker compose exec <service_name> ps aux (x to include process without shell)

## Docker network
docker network ls

docker network inspect <network_name>

docker network rm <network_name>
- for clean-up
