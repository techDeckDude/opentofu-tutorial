# OpenTofu Tutorial

This repository contains practical examples and tutorials for using [OpenTofu](https://opentofu.org/), an open-source infrastructure as code (IaC) tool that is a community-driven fork of Terraform. OpenTofu enables users to define, provision, and manage infrastructure resources across a wide variety of providers (cloud, on-premises, and local environments) using declarative configuration files.

## Table of Contents

- [Purpose](#purpose)
- [What is OpenTofu?](#what-is-opentofu)
- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Configuration Management](#configuration-management)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Purpose

The primary goal of this repository is to provide hands-on, working examples that demonstrate how to:

- Write OpenTofu configuration files (`.tf`) to define infrastructure resources
- Use OpenTofu to provision and manage infrastructure both locally (e.g., with Docker containers) and in the cloud (e.g., AWS, Azure, GCP)
- Understand best practices for state management, resource dependencies, and modularization
- Experiment with provider plugins, resource types, and data sources

## What is OpenTofu?

OpenTofu is an open-source tool for building, changing, and versioning infrastructure safely and efficiently. It uses a declarative language (HCL, HashiCorp Configuration Language) to describe the desired state of your infrastructure. OpenTofu then creates and manages resources such as virtual machines, networks, databases, and containers by interacting with provider APIs.

### Key Features

- **Declarative Configuration**: Define what you want, not how to do it
- **Execution Plans**: Preview changes before applying them
- **Resource Graph**: Automatically understands resource dependencies
- **State Management**: Tracks the real-world state of your infrastructure
- **Provider Ecosystem**: Supports a wide range of infrastructure platforms

## Architecture Overview

This repository includes an example configuration (`main.tf`) that provisions a PostgreSQL database using Docker:

- Pulls the official PostgreSQL image from Docker Hub
- Creates and configures a Docker container with environment variables, port mappings, and persistent storage
- Demonstrates how to use OpenTofu to manage local development infrastructure

## Prerequisites

Before getting started, ensure you have the following installed:

- [OpenTofu](https://opentofu.org/docs/intro/install/) (latest stable version)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine
- Git (for cloning this repository)

## Getting Started

### 1. Installation

Follow the instructions at [OpenTofu Installation](https://opentofu.org/docs/intro/install/) to install OpenTofu for your operating system.

### 2. Repository Setup

```bash
git clone https://github.com/yourusername/opentofu-tutorial.git
cd opentofu-tutorial
```

### 3. Configuration

Copy the environment template and configure your variables:

```bash
cp .env.example .env
```

Edit the `.env` file with your desired values:

```bash
TF_VAR_postgres_db=mydb
TF_VAR_postgres_user=myuser
TF_VAR_postgres_password=your_secure_password
```

### 4. Infrastructure Deployment

Initialize and apply the configuration:

```bash
# Initialize the OpenTofu configuration
tofu init

# Preview the execution plan
tofu plan

# Apply the configuration
source .env && tofu apply

# View the current state
tofu show

# Destroy resources when done
tofu destroy
```

## Configuration Management

### Environment Variables

OpenTofu supports multiple methods for managing configuration variables:

#### Method 1: Environment Variables (Recommended)

```bash
# Set environment variables with TF_VAR_ prefix
export TF_VAR_postgres_password=secret
tofu apply
```

#### Method 2: Variable Files

Create a `terraform.tfvars` file (automatically gitignored):

```hcl
postgres_db       = "mydb"
postgres_user     = "myuser"
postgres_password = "secure_password"
```

#### Method 3: Command Line Variables

```bash
tofu apply -var="postgres_password=secret_password"
```

### Secrets Management

For production environments, consider these approaches:

- **AWS Secrets Manager**: Store sensitive data in AWS and retrieve via data sources
- **HashiCorp Vault**: Centralized secrets management
- **Environment-specific variable files**: Separate `.tfvars` files per environment

## Usage Examples

### Connecting to PostgreSQL

Once the container is running, connect using:

```bash
docker exec -it postgres_container psql -U myuser -d mydb
```

### Viewing Container Status

```bash
docker ps
docker logs postgres_container
```

## Best Practices

1. **State Management**: Use remote state storage for team collaboration
2. **Version Control**: Pin provider versions in your configuration
3. **Security**: Never commit sensitive data; use proper secrets management
4. **Documentation**: Keep configuration files well-documented
5. **Testing**: Validate configurations with `tofu plan` before applying

## Troubleshooting

### Common Issues

1. **Docker not running**: Ensure Docker Desktop is started
2. **Port conflicts**: Check if port 5432 is already in use
3. **Permission errors**: Verify Docker has necessary permissions
4. **State lock issues**: Use `tofu force-unlock` if needed

### Volume Persistence

The PostgreSQL data is persisted at `/var/lib/postgresql/data`. Ensure this path exists and has proper permissions.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

---

**Note**: This tutorial is designed for learning purposes. For production deployments, implement additional security measures, monitoring, and backup strategies.