# How to
* install terraform & ansible
* `cp sample.env .env` and then adjust it properly. One could use `ssh-keygen -t ed25519` to make SSH key
* create a server using Terraform:
    ```sh
    source ./.env
    terraform init
    terraform apply
    ```