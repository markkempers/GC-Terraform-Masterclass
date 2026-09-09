# OCI Landing Zone - Basic

This repository is the base material for an IT students masterclass on Infrastructure as Code, combining **Terraform** and **Ansible** to build and configure resources on Oracle Cloud Infrastructure (OCI).

## Repository structure

| Folder | Description |
|---|---|
| [Terraform/](Terraform/) | Terraform configuration that provisions the OCI landing zone (compartment, VCN, subnet, gateway, route table, security list, compute instance). See [Terraform/README.MD](Terraform/README.MD) for details. |
| [Ansible/](Ansible/) | Ansible playbooks used to configure the compute instance(s) created by Terraform. |

## Prerequisites

You work from a local **Oracle Linux 9** virtual machine (VirtualBox, VMware, UTM, ...) running on your own laptop. The steps below prepare that VM with everything needed for the masterclass: Terraform, Ansible and the OCI CLI.

### 1. Install required packages

```bash
sudo dnf install -y git unzip
```

### 2. Install Terraform

```bash
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install -y terraform
terraform -version
```

### 3. Install Ansible

Oracle Linux 9 ships `ansible-core` through the AppStream repository:

```bash
sudo dnf install -y ansible-core
ansible --version
```

> If `ansible-core` cannot be found, enable the EPEL repository first and try again:
>
> ```bash
> sudo dnf install -y oracle-epel-release-el9
> sudo dnf install -y ansible-core
> ```

### 4. Install and configure the OCI CLI

The OCI CLI is used to generate/manage the API signing key used by the Terraform OCI provider, and is handy for verifying resources from the command line.

> If you launched your Oracle Linux 9 machine from the official OCI platform image, the OCI CLI is **already preinstalled** — skip straight to `oci setup config` below. It is only missing on a generic/on-prem/VirtualBox Oracle Linux 9 install. In that case, install it first:
>
> ```bash
> sudo dnf install -y oci-cli
> ```

```bash
oci setup config
```

`oci setup config` will:

- Ask for your tenancy OCID, user OCID and region.
- Generate an API signing key pair (or let you reuse an existing one).
- Upload the public key to your OCI user account (**Identity & Security > Users > your user > API Keys**).
- Write a config file to `~/.oci/config`, using the `DEFAULT` profile.

This `DEFAULT` profile is what the Terraform OCI provider uses (`config_file_profile = "DEFAULT"`) — see [Terraform/provider.tf](Terraform/provider.tf).

Verify the CLI can reach your tenancy:

```bash
oci iam region list
```

### 5. Clone this repository

```bash
git clone <repository-url>
cd oci-landingzone-basic
```

## Next steps

- Provision the OCI landing zone with Terraform: see [Terraform/README.MD](Terraform/README.MD).
- Configure the resulting compute instance(s) with Ansible: see the [Ansible/](Ansible/) folder.
