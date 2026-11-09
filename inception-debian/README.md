<!-- *This project has been created as part of the 42 curriculum by login.* -->

# Inception (Debian)

## Description

Inception builds a small web stack with Docker Compose inside a virtual machine. Three containers, each built from a Dockerfile in this repository on top of `debian:bookworm`:

- `nginx` terminates TLS on port 443, the only port open to the outside.
- `wordpress` runs WordPress on php-fpm 8.2 and listens on port 9000 inside the Docker network.
- `mariadb` stores the WordPress database and listens on port 3306 inside the Docker network.

Two named volumes keep the database and the site files under `/home/login/data` on the host, so containers can be destroyed and rebuilt without losing content.

This is the Debian version of the project. My original submission used Alpine. The section "Alpine vs Debian" lists every place the two differ.

## Instructions

Requirements: a Linux VM with Docker Engine, the Compose plugin, `make`, `openssl` and `sudo`.

`login` is a placeholder throughout this repository. Replace it with your own 42 login in `srcs/.env.example` (`DOMAIN_NAME`, `DATA_PATH`), in the first line of this README, and in the commands below.

```sh
echo "127.0.0.1 login.42.fr" | sudo tee -a /etc/hosts
make
```

`make` copies `srcs/.env.example` to `srcs/.env` if it is missing, generates any missing password files in `secrets/`, creates the data directories and starts the stack. Open https://login.42.fr and accept the self-signed certificate.

| Target | Effect |
|---|---|
| `make` / `make up` | build images and start the stack |
| `make down` | stop and remove containers, keep data |
| `make stop` / `make start` | pause and resume containers |
| `make ps` / `make logs` | status and live logs |
| `make clean` | remove containers, images and volume definitions |
| `make fclean` | `clean`, then delete `/home/login/data` |
| `make re` | `fclean`, then `make` |

[USER_DOC.md](USER_DOC.md) covers day-to-day use. [DEV_DOC.md](DEV_DOC.md) covers setup from scratch and internals.

## Project description

### How Docker is used here

Each service has its own directory in `srcs/requirements/` with a `Dockerfile`, a `conf/` directory for config files copied into the image, and a `tools/` directory for the entrypoint script. `srcs/docker-compose.yml` builds the three images, names each one after its service with an `:inception` tag, and wires them together with one bridge network, two volumes and four secrets.

Each container runs one process as PID 1. The entrypoint scripts do their one-time setup and then `exec` the daemon in the foreground (`mariadbd`, `php-fpm8.2 -F`, `nginx -g "daemon off;"`). The daemon receives `SIGTERM` from `docker stop` directly, and when it dies the container exits and `restart: always` brings it back.

### Design choices

- **Debian 12 (bookworm).** Debian 13 (trixie) is the current stable release, so bookworm is the penultimate one. It ships nginx 1.22, PHP 8.2 and MariaDB 10.11.
- **WordPress is downloaded at build time** into `/usr/src/wordpress`, at a pinned version. On first start the entrypoint copies it into the empty volume. Startup needs no network access and every build gets the same WordPress.
- **The entrypoints are idempotent.** Each setup step checks for its own result first: the MariaDB system tables, the WordPress database, `wp-config.php`, an installed site. Restarting a container skips the work that is already done.
- **MariaDB has a healthcheck**, and `wordpress` waits for `service_healthy` before starting. That replaces the `while ! mariadb ...; do sleep 2; done` loop that usually sits at the top of the WordPress entrypoint.
- **nginx resolves `wordpress` at request time** through Docker's DNS (`resolver 127.0.0.11`). When the WordPress container restarts and comes back with a new IP, nginx follows it instead of returning 502 until it is restarted itself.
- **Logs go to stdout/stderr**, so `docker logs` shows nginx access logs and php-fpm errors. Debian writes both to files under `/var/log` by default.
- **The certificate is generated at build time** for `DOMAIN_NAME`, passed in as a build argument.

### Alpine vs Debian

| | Alpine 3.x | Debian bookworm |
|---|---|---|
| Install | `apk add --no-cache pkg` | `apt-get update && apt-get install -y --no-install-recommends pkg && rm -rf /var/lib/apt/lists/*` in one `RUN` |
| PHP packages | `php82`, `php82-fpm`, `php82-mysqli` | `php8.2-fpm`, `php8.2-cli`, `php8.2-mysql` |
| php-fpm binary | `php-fpm82` | `php-fpm8.2` |
| php-fpm pool file | `/etc/php82/php-fpm.d/www.conf` | `/etc/php/8.2/fpm/pool.d/www.conf` |
| php-fpm default listen | `127.0.0.1:9000` | unix socket `/run/php/php8.2-fpm.sock` |
| `php` CLI | needs a symlink to `php82` | `php8.2-cli` installs `/usr/bin/php` |
| Web user | `nobody` or `nginx` | `www-data` (uid 33 in both containers) |
| MariaDB config | `/etc/my.cnf.d/` | `/etc/mysql/mariadb.conf.d/`, read in name order |
| MariaDB networking | `skip-networking` is on in `mariadb-server.cnf` | `bind-address = 127.0.0.1` in `50-server.cnf`, overridden by `90-inception.cnf` |
| `/var/lib/mysql` after install | empty | already initialised by the package, wiped in the Dockerfile |
| nginx config | `http.d/` | `sites-enabled/default` exists and is removed |
| Shell in base image | `sh` (BusyBox), add `bash` yourself | `bash` included |
| Base image size | ~8 MB | ~120 MB |

The `www-data` row matters more than it looks. nginx and php-fpm share the WordPress volume, and on Debian both run as uid 33, so file ownership lines up without any extra work. On Alpine, nginx runs as `nginx` and php-fpm as `nobody`, and you have to pick one.

### Virtual machines vs Docker

A VM emulates hardware and boots a full guest kernel. A container is a group of ordinary processes on the host kernel, isolated with namespaces and limited with cgroups. Containers start in a second and share the host's memory, but they give weaker isolation, and every container must run on the host's kernel. This project uses both: the VM gives each student the same Linux host, and Docker splits the services inside it.

### Secrets vs environment variables

Environment variables are visible in `docker inspect`, in `/proc/<pid>/environ`, and in every child process. Compose secrets are files mounted at `/run/secrets/<name>` inside only the containers that list them, and they never show up in `docker inspect`. Here `srcs/.env` holds non-sensitive settings (domain, database name, usernames) and `secrets/*.txt` holds the four passwords. Both paths are in `.gitignore`.

### Docker network vs host network

With `network_mode: host` a container shares the host's network stack: every port it opens is open on the host, and containers cannot reach each other by name. The `inception` bridge network gives each container its own address and DNS name (`mariadb`, `wordpress`, `nginx`). Only ports listed under `ports:` reach the host, and in this stack that is 443 on nginx.

### Docker volumes vs bind mounts

A bind mount maps a host path straight into a container, and Docker does not manage it. A named volume is an object Docker creates and tracks (`docker volume ls`, `docker volume inspect`), and its name is all the compose file needs to reference. The subject wants named volumes whose data lives in `/home/login/data`, so both volumes use the `local` driver with `type: none, o: bind, device: ...`. Docker manages them as volumes and stores their content at the path we chose.

## Resources

- Dockerfile best practices: https://docs.docker.com/build/building/best-practices/
- Compose file reference: https://docs.docker.com/reference/compose-file/
- Compose secrets: https://docs.docker.com/compose/how-tos/use-secrets/
- Debian releases: https://www.debian.org/releases/
- nginx SSL module: https://nginx.org/en/docs/http/ngx_http_ssl_module.html
- php-fpm configuration: https://www.php.net/manual/en/install.fpm.configuration.php
- MariaDB `mariadb-install-db` and bootstrap mode: https://mariadb.com/kb/en/mariadb-install-db/
- WP-CLI commands: https://developer.wordpress.org/cli/commands/
- Why PID 1 matters in containers: https://github.com/krallin/tini#why-tini

### Use of AI

I used Claude Code to port my Alpine submission to Debian: translating package names and paths, drafting the Dockerfiles and entrypoints, and writing the first version of these docs. I tested the result locally and checked TLS versions, restart after a crash, and persistence across `make down`/`make`.
