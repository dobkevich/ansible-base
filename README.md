# Ansible Server Base Configuration

A collection of Ansible playbooks and roles for initial Debian/Ubuntu server setup, hardening, and base configuration. This project automates common tasks needed to prepare a fresh server for production use.

## Features

- **Initial Remote Setup**: Automates the transition from a default root login to a hardened Ansible-managed configuration.
- **Security Hardening**:
  - Custom SSH port (default: 54018).
  - Disabling password authentication and direct root login.
  - IPTables initial configuration.
  - Kernel tuning (sysctl) for security and performance.
- **System Configuration**:
  - Locale generation and timezone setup.
  - Swap file creation.
  - Systemd-resolved for DNS management.
  - Logrotate configuration for standard services and SFTP.
  - Exim4 installation for local mail delivery.
- **User Experience**:
  - Administrative user creation (default user 'z') with SSH keys and sudo access.
  - Custom user profiles (Bash, Screen, Midnight Commander with syntax highlighting).
- **Package Management**: Installation of a set of common utility packages.

## Project Structure

- `admin_user.yml`: Playbook to create and configure an administrative user.
- `base_init.yml`: Initial server setup (iptables and basic packages).
- `base.yml`: Main playbook for full system configuration (all roles).
- `init-remote.sh` & `init-remote.yml`: Helper scripts for the very first connection to a raw server.
- `roles/`:
  - `exim`: Local mail delivery.
  - `iptables_init`: Basic firewall rules.
  - `kernel`: Sysctl hardening (64-bit and common).
  - `locale`: System locale configuration.
  - `logrotate`: Log rotation policies.
  - `packages`: Standard server utilities.
  - `ssh`: Hardened SSH and SFTP configuration.
  - `swap`: Managed swap file.
  - `systemd-resolved`: DNS configuration.
  - `timezone_chrony`: Time synchronization and timezone.
  - `user_profiles`: Custom CLI environment (bash, mc, screen).

## Prerequisites

- Ansible installed on your local machine.
- A fresh Debian-based server (Debian/Ubuntu) with root SSH access.

## Quick Start

### 1. Initial Initialization
To bootstrap a new server (creates `ansible` user, sets up administrative user 'z', changes SSH port to 54018):

```bash
./init-remote.sh <server_ip>
```

### 2. Full Configuration
Once initialized, you can run the full base configuration:

```bash
ansible-playbook base.yml -i inventory/inventory.yml
```

## Configuration

### Variables
- **SSH Port**: The project uses port `54018` by default (defined in `ansible.cfg` and `inventory/group_vars/all.yml`).
- **Administrative User**: Defined in `admin_user.yml`. You should change the `admin_username`, `ssh_public_key`, and `admin_password_sha512_hash` before use.

### Inventory
The default inventory is located in `inventory/inventory.yml`. Update it with your server addresses.

## Security Warning
This repository contains a sample SSH public key and a hashed password in `admin_user.yml`. **DO NOT** use these in a production environment. Replace them with your own credentials:
- Generate a password hash: `mkpasswd --method=sha-512`
- Use your own Ed25519 or RSA SSH public key.

## License
MIT
