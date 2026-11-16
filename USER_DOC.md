# User documentation

## What services are provided by the stack
- NGINX: the HTTPS server
- MariaDB: the database
- WordPress (the website) with php-fpm to run the `.php` files

## Start and stop the project
To start the project (and build it if needed) open a terminal and run:
```bash
make
```

To stop the project (containers) while keeping the data, run:
```bash
make down
```

To erase the data (database and website), run:
```bash
make fclean
```

## Access the website and the administration panel
1. Open a web browser (Firefox, Chrome)
2. Enter `https://canguyen.42.fr` in the address bar  
If the web browser is unable to connect, check that the domain points to the local machine (see [DEV_DOC.md](./DEV_DOC.md) for more details)
3. The web browser will warn that the website might be insecure (because the certificate is self-signed). Click on `Proceed to canguyen.42.fr (Risky)` or a similar message
4. To access the admin panel, go to `https://canguyen.42.fr/wp-admin` and enter the admin or user credentials

## Locate and manage credentials
Non-confidential information such as the domain name and usernames is saved as environment variables in the `srcs/.env` file and confidential information is saved as secrets (located in the `secrets` folder) with one `.txt` file per secret. Once the project is built (`make` or `make up`), editing these files would break the login.  
To change a password, you need to run `make fclean`, edit the `.txt` file and run `make` again.

## Check the services
To check the services are running correctly, open a terminal and run:
```bash
make ps
```
You should see 3 lines with `STATUS` Up for the 3 containers: `inception-mariadb-1`, `inception-nginx-1` and `inception-wordpress-1`

If you want to see the logs, run in a terminal:
```bash
make logs
```
