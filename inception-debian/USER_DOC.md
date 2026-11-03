# User documentation

## What the stack provides

| Service | What it does | Reachable from |
|---|---|---|
| nginx | HTTPS front door, TLS 1.2 and 1.3 only | host, port 443 |
| WordPress | the website and its admin panel | nginx only |
| MariaDB | the WordPress database | WordPress only |

## Start and stop

Run these from the repository root.

```sh
make          # build if needed, then start everything
make stop     # pause the containers
make start    # resume them
make down     # remove the containers; site content stays
```

## Open the site

The domain has to point at the machine running the stack. On the VM:

```sh
echo "127.0.0.1 login.42.fr" | sudo tee -a /etc/hosts
```

- Website: https://login.42.fr
- Admin panel: https://login.42.fr/wp-admin

The certificate is self-signed, so the browser shows a warning the first time. Accept it to continue.

## Credentials

Usernames are in `srcs/.env`. Passwords are in `secrets/`, one file each.

| Account | Username variable | Password file |
|---|---|---|
| WordPress administrator | `WP_ADMIN_USER` | `secrets/wp_admin_password.txt` |
| WordPress author | `WP_USER` | `secrets/wp_user_password.txt` |
| MariaDB user for WordPress | `MYSQL_USER` | `secrets/db_password.txt` |
| MariaDB root | `root` | `secrets/db_root_password.txt` |

`make` generates any missing password file with a random value. Read one with `cat secrets/wp_admin_password.txt`.

The passwords take effect when the site is first installed. Editing a file later does not change an existing account. To change a WordPress password, use the admin panel, or:

```sh
docker exec wordpress wp user update siteowner --user_pass='new-password' --allow-root
```

To start over with the values currently in `secrets/`, run `make re`. This deletes all site content.

## Check that it works

```sh
make ps
```

All three containers should show `Up`, and `mariadb` should show `(healthy)`.

```sh
make logs                          # live logs from all three
docker logs wordpress              # one service
curl -kI https://login.42.fr      # expect HTTP/1.1 200 OK
```
