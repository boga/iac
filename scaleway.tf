terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
#  access_key      = "<SCW_ACCESS_KEY>"
#  secret_key      = "<SCW_SECRET_KEY>"
  project_id	    = var.project_id
  zone            = "nl-ams-1"
  region          = "nl-ams"
}

resource "scaleway_instance_ip" "public-ip" {
  project_id	  = var.project_id
  zone            = "nl-ams-1"    
}

resource "scaleway_instance_security_group" "security-group" {
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = "22"
  }

  inbound_rule {
    action = "accept"
    port   = "80"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
  }
}

resource "scaleway_instance_server" "instance" {
  type  = "STARDUST1-S"
  image = "ubuntu_focal"
  name  = var.server_name

  ip_id = scaleway_instance_ip.public-ip.id
  security_group_id = scaleway_instance_security_group.security-group.id

  root_volume {
    size_in_gb = 10
  }
}