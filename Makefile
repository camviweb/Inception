COMPOSE	= docker compose -f srcs/docker-compose.yml

include srcs/.env
export

all: up

up:
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down -v

.PHONY: all up down
