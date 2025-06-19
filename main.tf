terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

variable "postgres_db" {
    description = "PostgreSQL database name"
    type        = string
    default     = "mydb"
}

variable "postgres_user" {
    description = "PostgreSQL username"
    type        = string
    default     = "myuser"
}

variable "postgres_password" {
    description = "PostgreSQL password"
    type        = string
    sensitive   = true
}

provider "docker" {
  
}

#Pull the PostgreSQL Docker image
resource "docker_image" "postgres" {
    name = "postgres:latest"
    keep_locally = false
}

#Create the PostgreSQL container
resource "docker_container" "postgres" {
    image = docker_image.postgres.image_id
    name = "postgres_container"
    
    #Container Environment variables for PostgreSQL
    env = [
        "POSTGRES_DB=${var.postgres_db}",
        "POSTGRES_USER=${var.postgres_user}",
        "POSTGRES_PASSWORD=${var.postgres_password}"
    ]

    #Container Port mapping for PostgreSQL
    ports {
        internal = 5432
        external = 5432
    }

    #Container Volumes for data persistence
    volumes {
        host_path      = "/var/lib/postgresql/data"
        container_path = "/var/lib/postgresql/data"
    }

    #Restart policy for the container
    restart = "unless-stopped"

    
    # Run OpenTofu to create infra:
    # Save it as main.tf
    # Run tofu init to initialize the configuration
    # Run tofu plan to see what will be created
    # Run tofu apply to create the container
    # Run tofu destroy to remove the container when done
    # Run tofu show to see the current state of the infrastructure
    
    #Command to connect to postgres on continaer: # docker exec -it postgres_container psql -U myuser -d mydb
    
    # Gotchas:
        # 1. Ensure Docker is both installed and running on your machine. (probably need to use OS level tool to ensure docker is restarted if it crashes)
        # 2. Ensure the host path for volumes exists and has the right permissions.
        # 3. The PostgreSQL image will create a new database, user, and password as specified in the environment variables.
        # 4. The container will restart unless stopped, which is useful for development environments.
        # 5. The PostgreSQL port is mapped to the host, allowing you to connect to it from outside the container.
        # 6. The PostgreSQL data is persisted in the host path to ensure data is not lost when the container is removed.
        # 7. The PostgreSQL image is pulled from Docker Hub, so ensure you have internet access to download it.
        # 8. The PostgreSQL version is set to latest, which may change over time. Consider pinning to a specific version for production use.
        # 9. In order to run the infra deployment (main.tf) you need to have OpenTofu installed and configured on your machine and be in the directory where the main.tf file is located.
        # 10. State files can be stored locally and remotely (e.g., in an S3 bucket) for team collaboration, but this example uses local state. Therefore the files can become out of sync

}
