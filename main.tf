# main.tf

# 1. Configure the Terraform block to require the Docker provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1" # Use a specific version for consistency
    }
  }
}

# 2. Configure the Docker provider
# (No configuration needed if Docker is running locally on the same machine)
provider "docker" {}

# 3. Pull the nginx image (Best Practice)
# This resource explicitly pulls the image before using it.
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false # Set to false so 'terraform destroy' removes the image
}

# 4. Create the Docker container
# This resource depends on the 'docker_image' resource above.
resource "docker_container" "nginx_server" {
  # Use the image_id from the 'docker_image' resource.
  # This creates an *implicit dependency*.
  image = docker_image.nginx.image_id
  name  = "task3-nginx-container"

  ports {
    internal = 80   # The port inside the container
    external = 8080 # The port on the EC2 host machine
  }
}
