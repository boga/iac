variable "project_id" {
  type        = string
  description = "The id of the Scaleway project ( https://console.scaleway.com/project/settings )"
}

variable "server_name" {
  type        = string
  description = "The name for the server"
}

variable "ansible_ssh_key" {
  type        = string
  description = "SSH key to be used for Ansible operations"
}

variable "ssh_port" {
  type        = number
  description = "Port for SSH server"
  default = 32567
}
