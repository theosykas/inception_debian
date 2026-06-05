# Inception - Developer Documentation

This document provides technical instructions for developers to set up, build, and manage the Inception infrastructure. It details the underlying mechanisms of the Docker configuration and persistent storage.

## Setting up the environment from scratch

Before building the infrastructure, the environment must be correctly initialized.

### Prerequisites
- A Debian-based environment (Virtual Machine is mandatory for the evaluation).
- `docker` engine installed and running.
- `docker compose` plugin installed.
- `make` utility installed.
- `sudo` privileges (required to manage host directories created by Docker).

### Configuration Files
The core infrastructure is defined in `srcs/docker-compose.yml`. Each service has its specific `Dockerfile` located in:
- `srcs/requirements/nginx/`
- `srcs/requirements/wordpress/`
- `srcs/requirements/mariadb/`

### Secrets & Environment Variables
Credentials and sensitive settings must be defined before runtime.
0. Make build || up init /secret with correponding .txt for cat the secrets password into script

1. Duplicate the template file: `cp srcs/.env.exemple srcs/.env`
2. Edit `srcs/.env` to include your specific passwords and settings. This file is ignored by `.gitignore` to prevent secret leaks. the makefile have a rule in build to effectuate this action:

```bash
if [ ! -f src/.env ]; then cp src/.env.exemple src/.env; fi
```
the .env is not track by git but we have a .env.exemple we copy the .env.exemple into a real .env in first build of the project

3. Configure the local domain resolution by adding your domain to the host machine:
```bash
echo "127.0.0.1 thsykas.42.fr" | sudo tee -a /etc/hosts
```

## Building and launching the project

The entire build and launch process is automated via the root `Makefile`.

### Makefile and Docker Compose

The `Makefile` acts as a wrapper around the `docker compose -f srcs/docker-compose.yml` command.

To build the images and ensure the host directories are created:

```bash
make build
```

This command triggers the `init_create_dir` rule first, which executes `mkdir -p /home/thsykas/data/mariadb_volume /home/thsykas/data/wordpress_volume`. It then proceeds to build the custom images.

To launch the project in detached mode:

```bash
make up
```

## Managing containers and volumes

Use the relevant `Makefile` commands to manage the infrastructure lifecycle.

### Relevant Commands

* **View active containers**:

```bash
make ps
```

* **Inspect service logs**:

```bash
make logs
```

* **Tear down the environment**:

```bash
make down
```

This command stops the containers and removes the containers, default networks, and Docker volumes defined in the compose file (`docker compose down -v`). However, it *does not* delete the physical files on the host machine.

* **Deep Clean (fclean)**:

```bash
make fclean
```

This executes the `down` rule and forces the deletion of the physical data directories on the host using `sudo rm -rf /home/thsykas/data/mariadb_volume /home/thsykas/data/wordpress_volume`.

## Data persistence and storage

Data persistence is handled by combining Docker named volumes and host machine directories.

### Where project data is stored

Docker creates internal named volumes, which are mapped to specific physical directories on the host machine.

* **MariaDB Data**: Stored physically in `/home/thsykas/data/mariadb_volume`.
* **WordPress Data**: Stored physically in `/home/thsykas/data/wordpress_volume`.

### How data persists

Because the Docker volumes are mapped to static directories on the host (`/home/thsykas/data/...`), the data remains intact even if the containers are stopped, removed, or rebuilt.
When containers are launched again via `make up`, Docker remounts these host directories into the containers, restoring the database and the website files to their exact previous state. The data is only lost if the host directories are manually deleted (e.g., by running `make fclean`).