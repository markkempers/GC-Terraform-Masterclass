# OCI Landing Zone - Basic

This repository contains a basic Terraform setup for Oracle Cloud Infrastructure (OCI). It is used as a starting point for an IT students masterclass on Infrastructure as Code with Terraform.

## Resources created

Running this Terraform configuration will create the following resources in your OCI tenancy:

| Resource | Terraform type | Description |
|---|---|---|
| Compartment | `oci_identity_compartment` | A dedicated compartment (`tf-demo`) to isolate all demo resources from the rest of the tenancy |
| Virtual Cloud Network (VCN) | `oci_core_vcn` | The network (`10.10.0.0/16`) that all other network resources live in |
| Subnet | `oci_core_subnet` | A public subnet (`10.10.1.0/24`) inside the VCN |
| Internet Gateway | `oci_core_internet_gateway` | Allows resources in the VCN to reach (and be reached from) the internet |
| Route Table | `oci_core_route_table` | Routes all outbound traffic (`0.0.0.0/0`) through the internet gateway |
| Security List | `oci_core_security_list` | Firewall rules for the subnet: allows inbound SSH (port 22) only from `var.students_cidr`, and allows all outbound traffic |

> **Note:** No compute instance (virtual machine) is created yet. Creating a VM in this network is the topic of the **next masterclass session**.

## Prerequisites

This lab assumes you work from an **Oracle Linux 9** machine (a local VM, a laptop, or an OCI compute instance).

### 1. OCI account and access

- An Oracle Cloud Infrastructure account/tenancy with permissions to create compartments, networking and compute resources.
- Your tenancy OCID.
- An OCI user with an API signing key configured (see below).

### 2. Install required packages

```bash
sudo dnf install -y git unzip
```

### 3. Install Terraform

```bash
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install -y terraform
terraform -version
```

### 4. Install and configure the OCI CLI

The OCI CLI is used to generate/manage the API key used by the Terraform OCI provider.

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

This `DEFAULT` profile is what [provider.tf](provider.tf) uses (`config_file_profile = "DEFAULT"`).

### 5. Clone this repository

```bash
git clone <repository-url>
cd oci-landingzone-basic
```

### 6. Configure variables

Adjust [variables.tf](variables.tf) / [terraform.tfvars](terraform.tfvars) as needed:

| Variable | Description | Default |
|---|---|---|
| `region` | OCI region to deploy into | `eu-amsterdam-1` |
| `tenancy_ocid` | Your OCI tenancy OCID | `ocid.xxxx` (must be set) |
| `students_cidr` | CIDR range allowed to SSH into the subnet | `192.168.1.0/24` |

At minimum, set `tenancy_ocid` to your own tenancy OCID and `students_cidr` to the CIDR your traffic originates from.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

To tear everything down again:

```bash
terraform destroy
```

## Next steps

In the next masterclass, we will extend this landing zone by adding a compute instance (virtual machine) into the subnet created here, using [compute.tf](compute.tf).
