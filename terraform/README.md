# Proxmox VM Terraform

This directory creates a Proxmox VM directly with the `bpg/proxmox` provider by downloading a public cloud image and importing it as the VM disk.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Fill in your Proxmox endpoint, API token, image URL, storage, network, and SSH key.
3. Run:

```sh
terraform init
terraform plan
terraform apply
```

## Notes

- The provider source is `bpg/proxmox`.
- The image is downloaded with `proxmox_virtual_environment_download_file` and attached using `disk.import_from`.
- For Debian 12 and Ubuntu cloud images, the config includes a serial device because the provider README calls that out as required to avoid kernel panics when resizing the boot disk.
- Keep API credentials out of versioned files when possible. `TF_VAR_*` environment variables are safer than committing `terraform.tfvars`.
