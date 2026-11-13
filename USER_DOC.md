# User documentation

## What services are provided by the stack
- NGINX : the HTTPS server
- MariaDB : the database
- WordPress (the website) with php-fpm to run the `.php` files

## Start and stop the project
1. Open a terminal and run:
```bash
make # to build and start
make down # to stop
```

## Access the website and the administration panel
1. Open a navigator (Firefox, Chrome)
2. Enter `canguyen.42.fr` in the search bar
3. The navigator is gonna warn that the website might be ensecured (as we auto-signed the certificate), you can click on `Proceed to canguyen.42.fr (Risky)` or a similar message
4. To access the admin panel, go to `canguyen.42.fr/wp-admin` and enter the admin or user credentials

## Locate and manage credentials
Unconfidential informations as the domain name and usernames are located in the .env file qnd confidential informations are located in the `secrets` folder.

## Check that the services are running correctly
1. Open a terminal and run:
```bash
make ps
```
You should see 3 lines for the 3 containers : `inception-mariadb-1`, `inception-nginx-1` and `inception-wordpress-1`

2. If you want to see the logs, run in a terminal:
```bash
make logs
```
