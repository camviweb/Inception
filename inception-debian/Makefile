# COMPOSE = docker compose -f srcs/docker-compose.yml
SECRETS = $(addprefix secrets/,db_root_password.txt db_password.txt wp_admin_password.txt wp_user_password.txt)

# -include srcs/.env
# export DATA_PATH

# all: up

up: srcs/.env $(SECRETS)
	@test -n "$(DATA_PATH)" || (echo "DATA_PATH is not set in srcs/.env" && exit 1)
# 	@mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	$(COMPOSE) up -d --build

# down:
# 	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down --rmi all --volumes

fclean: clean
	@test -n "$(DATA_PATH)" || (echo "DATA_PATH is not set in srcs/.env" && exit 1)
	sudo rm -rf $(DATA_PATH)

re: fclean all

srcs/.env:
	cp srcs/.env.example $@

secrets/%.txt:
	@mkdir -p secrets
	@openssl rand -hex 16 > $@
	@chmod 600 $@
	@echo "generated $@"

.PHONY: all up down start stop ps logs clean fclean re
