# TASK 3: Infrastructure as Code (IaC) with Terraform

This project demonstrates a fundamental Infrastructure as Code (IaC) workflow. It uses **Terraform** to provision and manage a local **Docker** container running an Nginx web server.

## Objective

Provision a local Nginx Docker container using Terraform, demonstrating the full IaC lifecycle: initialize, plan, apply, and destroy.

## Tools Used

* **Terraform:** The IaC tool used to define and manage the infrastructure.
* **Docker:** The container runtime that hosts the Nginx container.
* **Host Machine:** This project was run on an **AWS EC2 Ubuntu machine**.

---

## Files in This Repository

* `main.tf`: The core Terraform file defining the resources to be created.
* `.gitignore`: A standard Terraform gitignore file to exclude sensitive state files (`.tfstate`) and provider binaries (`.terraform`) from version control.

---

## How to Run This Project

### Prerequisites

You must have the following tools installed on your machine (e.g., your EC2 instance):
1.  **Terraform:** [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2.  **Docker:** [Installation Guide for Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
    * *Remember to add your user to the `docker` group:* `sudo usermod -aG docker ${USER}` *(You must log out and back in for this to take effect)*.

### Step-by-Step Execution

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```

2.  **Initialize Terraform (terraform init)**
    This command downloads the required Docker provider (`kreuzwerker/docker`).
    ```bash
    terraform init
    ```

3.  **Plan the Changes (terraform plan)**
    This command creates an execution plan, showing you exactly what resources Terraform will create, modify, or destroy. This is a "dry run."
    ```bash
    terraform plan
    ```

4.  **Apply the Changes (terraform apply)**
    This command executes the plan, pulling the Nginx image and starting the Docker container. You will be prompted to type `yes` to approve.
    ```bash
    terraform apply
    ```

5.  **Verify the Container**
    Check that the container is running and accessible.
    ```bash
    # See the running container
    docker ps
    
    # Test the Nginx server
    curl localhost:8080 
    # You should see the "Welcome to nginx!" HTML output
    ```

6.  **Destroy the Infrastructure (terraform destroy)**
    Once you are finished, this command will read your state file and cleanly remove all resources managed by Terraform (the container and the image).
    ```bash
    terraform destroy
    ```

---

## Code Explanation (`main.tf`)

* **`terraform { ... }`**: This block defines the required providers for the project. We specify the `kreuzwerker/docker` provider.
* **`provider "docker" { ... }`**: This block configures the Docker provider. Since we are using a local Docker socket, no extra configuration is needed.
* **`resource "docker_image" "nginx" { ... }`**: This resource tells Terraform to manage a Docker image. It will pull `nginx:latest` from Docker Hub.
* **`resource "docker_container" "nginx_server" { ... }`**: This resource creates the container.
    * `image = docker_image.nginx.image_id`: This line creates an **implicit dependency**. It tells Terraform to use the ID of the image from the resource above, ensuring the image is pulled *before* the container is created.
    * `name = "task3-nginx-container"`: A friendly name for our container.
    * `ports { ... }`: Maps port `80` *inside* the container to port `8080` on the *host machine* (your EC2 instance).

## Deliverables

1.  **`main.tf`**: Included in this repository.
2.  **Execution Logs**: The console output from running `terraform init`, `terraform plan`, `terraform apply`, `docker ps`, `terraform state list`, and `terraform destroy` serve as the execution logs for this task.
