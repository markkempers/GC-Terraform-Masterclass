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

Before using this Terraform configuration, make sure your machine is set up as described in the [repository root README](../README.MD): an Oracle Linux 9 VM with Terraform and the OCI CLI installed, and `oci setup config` completed (this is what provides the `DEFAULT` profile used by [provider.tf](provider.tf) via `config_file_profile = "DEFAULT"`).

You will also need:

- An Oracle Cloud Infrastructure account/tenancy with permissions to create compartments, networking and compute resources.
- Your tenancy OCID.

### Configure variables

Adjust [variables.tf](variables.tf) / [terraform.tfvars](terraform.tfvars) as needed:

| Variable | Description | Default |
|---|---|---|
| `region` | OCI region to deploy into | `eu-amsterdam-1` |
| `tenancy_ocid` | Your OCI tenancy OCID | `ocid.xxxx` (must be set) |
| `students_cidr` | CIDR range allowed to SSH into the subnet | `192.168.1.0/24` |

At minimum, set `tenancy_ocid` to your own tenancy OCID and `students_cidr` to the CIDR your traffic originates from.

## Usage

The Terraform state file (`terraform.tfstate`) is kept **outside this repository** so it never gets committed, overwritten by `git pull`, or wiped by `git clean`. This is configured via a [local backend](provider.tf) with a relative `path` that climbs out of the repo, so it ends up next to (not inside) the cloned repository.

```bash
terraform init
terraform plan
terraform apply
```

> The state file lands at `../../.terraform-state/oci-landingzone-basic/terraform.tfstate` relative to this directory, i.e. a sibling of wherever you cloned the repo. Terraform creates that directory automatically. If you cloned somewhere unusual and want state elsewhere instead, run `terraform init -reconfigure -backend-config="path=<your-path>"`.

To tear everything down again:

```bash
terraform destroy
```

## Next steps

In the next masterclass, we will extend this landing zone by adding a compute instance (virtual machine) into the subnet created here, using [compute.tf](compute.tf).
