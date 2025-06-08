# DevOps Internship Project – Gogs Infrastructure

This project demonstrates my DevOps skills by maintaining a Gogs (Git service) infrastructure using various modern tools and technologies. The stack includes virtualization, configuration management, CI/CD, monitoring, and reverse proxy setup.

## Technologies Used

- **Vagrant** – for virtual machine management
- **VirtualBox** – virtualization provider
- **Ansible** – for configuration management and continuous deployment (CD)
- **Nginx** – reverse proxy server for routing requests to Gogs instances
- **PostgreSQL** – database for Gogs
- **Jenkins** – continuous integration (CI)
- **Splunk Enterprise** – monitoring and log management
- **Splunk OpenTelemetry Collector** – agent for collecting telemetry data from servers
- **NFS** – network file system to save gogs repositories

## Getting Started

To get started with the project, make sure the following tools are installed on your local machine:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## How to Run the Infrastructure

Use the following commands to start the required servers:

```bash
vagrant up gogs1
vagrant up gogs2
vagrant up ansible
vagrant up nginx
vagrant up psql
```

You can check the status of all virtual machines with:

```bash
vagrant status
```

Once all machines are up, connect to the Ansible control node:

```bash
vagrant ssh ansible
```

Inside the Ansible VM, you can run playbooks to configure Gogs, Nginx, PostgreSQL, and monitoring services.

## README NOT FINISHED, Maybe in the future :)
