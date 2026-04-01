# Proxmox VM Terraform

This directory creates a Proxmox VM directly with the `bpg/proxmox` provider by downloading a public cloud image and importing it as the VM disk.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Fill in your Proxmox endpoint, image URL, storage, network, and SSH key.
3. Export the Proxmox API token variables.
4. Run:

```sh
terraform init
terraform plan
terraform apply
```

## Proxmox API Token

Create a dedicated API token in the Proxmox UI:

1. Open `Datacenter` -> `Permissions` -> `Users` and create a service user if you do not want to use an existing account.
2. Open `Datacenter` -> `Permissions` -> `API Tokens`.
3. Select the user and create a token, for example `terraform`.
4. Copy the token secret immediately. Proxmox only shows it once.
5. Grant that user or token the permissions it needs on the target node and storage.

The token ID format is:

```text
<user>@<realm>!<token-name>
```

Example:

```text
terraform@pve!iac
```

Export the token for Terraform with environment variables instead of storing it in a tracked `.tfvars` file:

```sh
export TF_VAR_proxmox_api_token_id='terraform@pve!iac'
export TF_VAR_proxmox_api_token_secret='replace-me'
```

You can then run Terraform normally:

```sh
terraform plan
terraform apply
```

If you also want to set an initial guest password through cloud-init, export that too:

```sh
export TF_VAR_vm_password='replace-me'
```

## Storage and Image Settings

`image_datastore_id` must be the Proxmox storage ID, not a filesystem path. If your storage is named `looner-ssd` in Proxmox, use:

```hcl
image_datastore_id = "looner-ssd"
```

For cloud image import:

```hcl
image_content_type = "import"
```

The target storage must have `Import` enabled in `Datacenter -> Storage -> <storage> -> Content`.

`file_name` must match the final imported disk format that Proxmox accepts, not the compressed archive suffix. Valid examples are `.raw`, `.qcow2`, and `.vmdk`.

Example for a compressed Talos image:

```hcl
image_url                = "https://factory.talos.dev/.../nocloud-amd64.raw.xz"
image_file_name          = "nocloud-amd64.raw"
image_content_type       = "import"
decompression_algorithm  = "xz"
```

Example for an uncompressed Debian image:

```hcl
image_url       = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
image_file_name = "debian-12-generic-amd64.qcow2"
```

If `file_name` uses the wrong extension, Proxmox returns:

```text
Parameter verification failed. (400)
filename: invalid filename or wrong extension
```

## Permissions

Proxmox permissions are assigned through ACL roles on paths such as `/`, `/storage/<storage>`, and `/vms`. For this workflow, the relevant paths are typically:

- `/`
- `/storage/<image_datastore_id>`
- `/storage/<disk_datastore_id>`
- `/vms`

Useful starting roles are:

- `/` -> `PVESysAdmin`
- `/storage/<storage>` -> `PVEDatastoreAdmin`
- `/vms` -> `PVEVMAdmin`

The token ID format is still:

```text
<user>@<realm>!<token-name>
```

In testing, even broad token permissions including `Administrator` on `/` did not fix the `proxmox_download_file` metadata failure below, so do not assume every 403 from this resource is caused only by missing ACLs.

## Known Issue

`terraform plan` can succeed while `terraform apply` still fails during `proxmox_download_file` creation with:

```text
Could not get file metadata ... GetQueryURLMetadata ... HTTP 403 ... Permission check failed
```

This was reproducible here with:

- multiple public image URLs
- a token with privilege separation disabled
- broad roles including `Administrator`

That means the Terraform configuration can be valid while the Proxmox `download-url` / metadata endpoint still rejects the request.

If you hit this:

1. Verify `image_datastore_id` is the Proxmox storage ID, for example `looner-ssd`.
2. Verify `image_content_type = "import"`.
3. Verify the storage has `Import` enabled.
4. Verify `file_name` uses the final disk-image extension, not `.xz` or `.gz`.
5. If the error persists, treat it as a Proxmox or provider limitation of `proxmox_download_file` in your environment.

The pragmatic fallback is to avoid provider-managed URL download and instead download the image outside Terraform, then upload or import it separately.

## Notes

- The provider source is `bpg/proxmox`.
- The image is downloaded with `proxmox_download_file` and attached using `disk.import_from`.
- For cloud image import, set `image_content_type = "import"` and enable `Import` in `Datacenter -> Storage` for the target storage.
- The current provider docs say this download resource requires `Datastore.AllocateTemplate`, `Sys.Audit`, and `Sys.Modify`.
- For Debian 12 and Ubuntu cloud images, the config includes a serial device because the provider README calls that out as required to avoid kernel panics when resizing the boot disk.
- Keep API credentials out of versioned files when possible. `TF_VAR_*` environment variables are safer than committing `terraform.tfvars`.
