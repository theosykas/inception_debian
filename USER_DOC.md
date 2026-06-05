# Inception - User Documentation

This document provides essential information for administrators and users to operate, manage, and verify the Inception infrastructure.

## Services provided by the stack
The infrastructure provides a complete, containerized WordPress stack secured by a reverse proxy.

- **Web Server (NGINX)**: Acts as the secure gateway. It handles SSL/TLS termination and routes traffic to the application.
- **Application (WordPress)**: The content management system running on `php-fpm`.
- **Database (MariaDB)**: The backend storage for all website content, users, and configurations.

## Start and stop project
All operations are centralized through the `Makefile` located at the root of the project.

### Starting the Stack
To initialize the environment, create the required physical directories, and launch all services in the background:
```bash
make up
```

### Stopping the Stack

To stop the services and remove the containers, networks, and Docker volumes (while keeping the physical files on the host machine):

```bash
make down
```

### Complete Wipe (Warning)

If you need to completely reset the project, removing containers, networks, and permanently deleting all physical data stored on the host:

```bash
make fclean
```

## Accessing the Website

Once the stack is running, the services are accessible via the configured domain.

### Public Website

* **URL**: `https://thsykas.42.fr`
* **Protocol**: HTTPS (Port 443)
* **Note**: Ensure that your `/etc/hosts` file points `thsykas.42.fr` to `127.0.0.1`.

### Administration Panel

* **URL**: `https://thsykas.42.fr/wp-admin`
* **Purpose**: Manage themes, plugins, and users. Use the credentials defined during the initial setup.

## Locate and manage credentials

For security reasons, credentials are not stored in the source code.

### Locating Credentials

* **File**: `srcs/.env` (This file contains database names, user logins, and passwords).
* **Security**: Never share this file or commit it to a repository.

### Managing Users

* **Administrator**: The primary user for full site control.
* **Secondary User**: An additional user (e.g., author/contributor) created for standard content management, as required by the project.

## Health Check & Monitoring

To ensure the infrastructure is running correctly, use the following tools:

### Status Check

Verify that all containers are "Up" and healthy:

```bash
make ps
```

### Log Monitoring

If the website is not responding, check the real-time logs of the containers:

```bash
make logs
```

### Data Persistence

Verify that your data is correctly stored on the host machine:

* **Database files**: `/home/thsykas/data/mariadb_volume`
* **WordPress files**: `/home/thsykas/data/wordpress_volume`

---

*For technical implementation details, infrastructure design, and environment setup, please refer to [DEV_DOC.md](https://www.google.com/search?q=./DEV_DOC.md).*



cd srcs
docker compose -p srcs ps

port 80 check
domain.42.fr:80 error == non port 80

clique cadenas pour check info on tls protocol