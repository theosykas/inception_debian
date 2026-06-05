*This project has been created as part of the 42 curriculum by thsykas*

# Inception - System Administration with Docker

## Description
This project focuses on system administration through virtualization. The objective is to build a complex infrastructure using Docker Compose. Every service runs in a dedicated container based on the
penultimate stable version of Debian, ensuring isolation and security.

The infrastructure consists of:

- **NGINX**: A web server acting as the unique entry point, secured with TLSv1.2 or TLSv1.3 via port 443.

**WordPress + php-fpm**: A pre-configured CMS environment.

- **MariaDB**: A relational database system for WordPress data.

- **Dedicated Volumes**: Persistent storage for both the database and website files.
- **Bridge Network**: A private network for inter-container communication.

---

## Project Description & Design Choices

### Core Architecture
Each image is custom-built using a specific `Dockerfile`. The use of ready-made images from DockerHub is strictly prohibited (except for the base Debian image), ensuring full control over the
configuration and security of the stack.

---

### Technical Comparisons

#### Virtual Machines vs Docker
- **Virtual Machines**: Virtualize at the hardware level. Each VM runs a full operating system, consuming significant disk space and RAM.

- **Docker**: Virtualizes at the OS kernel level. Containers share the host kernel, making them extremely lightweight, fast to start, and efficient in resource consumption.


#### Secrets vs Environment Variables

- **Environment Variables**: Simple to use for general configuration but potentially visible via system tools.

- **Docker Secrets**: A more secure approach for sensitive data. In this project, an `.env` file is used to store environment variables, and it is strictly excluded from version control for security
      reasons.

#### Docker Network vs Host Network

- **Host Network**: Direct exposure of container services to the host network interface, reducing isolation.

- **Docker Network (Bridge)**: Provides a virtual network bridge. Containers can only communicate with each other if they are on the same network, using their service names as hostnames.

#### Docker Volumes vs Bind Mounts
- **Bind Mounts**: Depend on the host's directory structure and permissions.

- **Docker Volumes**: Managed by Docker. They are more portable and secure. In this project, volumes are mapped to `/home/thsykas/data` on the host machine.

---

## Instructions

### Prerequisites
- A Debian-based Virtual Machine.
- Docker and Docker Compose installed.
- Sudo privileges for volume management.

### Configuration
**Setup Domain**: Add the following line to your `/etc/hosts` file: 127.0.0.1 thsykas.42.fr


**Environment Variables**: Create a `.env` file in the `srcs/` directory based on `.env.exemple`.

### Makefile Rules
The project is managed via a root `Makefile`. Use the following commands:
- **`make build`**: Creates the volume ories on the host and builds the Docker images.
- **`make up`**: Builds (if necessary) and starts the containers in detached mode.
- **`make down`**: Stops and removecontainers, networks, and volumes defined in the compose file.
- **`make ps`**: Lists all active contners.
- **`make logs`**: Displays real-time logor all services.
- **`make fclean`**: Executes `down` and deletes all physical data stored in `/home/thsykas/data`.

## Resources
- [Docker Documentation](https://docs.doc
ker. - [NGINX TLS Configuration](https://nginx.org/en/docs/http/configuring_https_servers.
html) - [WordPress CLI Implementation](https://make.wordpress.org/cli/handbook/)
MariaDB Security Best Practices](https://mariadb.com/kb/en/securing-mariadb/)

---

### AI Usage
   was utilized during this project as a technical or for the following tasks:
- **Conceptual Analysis**: Comparing virtualization technologies (VMs vs Containers).

- **Documentation**: Generating the initial structure of this README to ensure compliance withcurriculum requirements.
All logic was reviewed, manually tested, and understood before integration.


*Refer to [USER_DOC.md](./USER_DOC.md) and [DEV_DOC.md](./DEV_DOC.md) for more details on usage and development.*