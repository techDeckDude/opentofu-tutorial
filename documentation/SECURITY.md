# Security Guidelines for PostgreSQL Docker Configuration

## Overview

This document outlines security best practices for deploying PostgreSQL containers using OpenTofu/Terraform configurations. These guidelines help ensure secure deployment across development, staging, and production environments.

## Table of Contents

- [Secret Management](#secret-management)
- [Network Security](#network-security)
- [Container Security](#container-security)
- [Image Security](#image-security)
- [Access Control](#access-control)
- [Compliance and Monitoring](#compliance-and-monitoring)
- [Quick Reference](#quick-reference)

## Secret Management

### Password Handling
- **Never hardcode passwords** in configuration files
- Use the `sensitive = true` attribute for password variables
- Leverage secure secret stores for production deployments:
  - HashiCorp Vault
  - AWS Secrets Manager
  - Azure Key Vault
  - Google Secret Manager

### Environment Variable Security
- Inject secrets at runtime using environment variables
- Avoid exposing sensitive data in container logs
- Use Docker secrets when available for enhanced security

## Network Security

### Port Exposure
The PostgreSQL container exposes port 5432 by default. Apply these restrictions based on your environment:

#### Development Environment
Standard port mapping is acceptable for local development.

#### Production Environment
Restrict network access using these approaches:

```hcl
ports {
  internal = 5432
  external = "127.0.0.1:5432"
}
```

### Network Isolation
- Implement Docker networks to isolate containers
- Limit database access to trusted IP addresses only
- Consider using internal networks for multi-container applications

## Container Security

### Privilege Management
Containers should run with minimal required privileges:

```hcl
security_opts = ["no-new-privileges:true"]
```

### User Configuration
- Avoid running containers as root user
- Configure appropriate user directives in container images
- Implement least-privilege access principles

### Runtime Security
- Drop unnecessary Linux capabilities
- Use security profiles (AppArmor, SELinux) when available
- Enable container security scanning in CI/CD pipelines

## Image Security

### Version Management
- **Never use `latest` tags** in production
- Pin to specific, tested versions (e.g., `postgres:15.3`)
- Implement a regular update and testing cycle
- Maintain an inventory of approved base images

### Image Scanning
- Scan images for known vulnerabilities
- Use trusted image registries
- Implement image signing and verification

## Access Control

### File System Security
Volume mounts require careful permission management:

- Set appropriate ownership on host directories
- Avoid world-writable permissions
- Restrict mounting of sensitive host directories
- Use named volumes instead of bind mounts when possible

### Database Access
- Implement role-based access control (RBAC)
- Use connection limits and timeouts
- Enable audit logging for sensitive operations

## Compliance and Monitoring

### Logging
- Enable comprehensive audit logging
- Monitor for suspicious access patterns
- Implement log aggregation and analysis
- Ensure logs don't contain sensitive information

### Documentation
- Remove operational details from production code comments
- Maintain security documentation separately
- Document incident response procedures

## Quick Reference

### Essential Security Checklist

- [ ] Secrets managed via secure secret stores
- [ ] Network access restricted to trusted sources
- [ ] Container images pinned to specific versions
- [ ] File system permissions properly configured
- [ ] Container running with minimal privileges
- [ ] Audit logging enabled and monitored
- [ ] Security scanning integrated into deployment pipeline

### Recommended Configuration Example

```hcl
resource "docker_container" "postgres" {
  image = "postgres:15.3"  # Pinned version
  name  = "postgres-secure"
  
  ports {
    internal = 5432
    external = "127.0.0.1:5432"  # Localhost only
  }
  
  env = [
    "POSTGRES_DB=${var.database_name}",
    "POSTGRES_USER=${var.database_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}"  # From secret store
  ]
  
  security_opts = ["no-new-privileges:true"]
  
  volumes {
    host_path      = "/secure/postgres/data"  # Proper permissions
    container_path = "/var/lib/postgresql/data"
  }
}
```

---

**Note**: This document should be reviewed and updated regularly to reflect current security best practices and organizational policies.