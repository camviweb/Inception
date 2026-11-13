COMPOSE	= docker compose -f srcs/docker-compose.yml
SECRETS = $(addprefix secrets/,db_root_password.txt db_user_password.txt wp_admin_password.txt wp_user_password.txt)

include srcs/.env
export

all: up

up: srcs/.env $(SECRETS)
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	$(COMPOSE) up -d --build

srcs/.env:
	cp srcs/.env.example $@

secrets/%.txt:
	mkdir -p secrets
	openssl rand -hex 16 > $@
	chmod 600 $@

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down --rmi all -v

fclean: clean
	sudo rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress

re: fclean all

.PHONY: all up down stop start ps logs clean fclean re
