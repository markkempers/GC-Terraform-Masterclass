terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "9.0.0"
    }
  }

  backend "local" {
    # Relative to this directory (Terraform/), so it resolves outside the
    # git repo for every student regardless of where they cloned it.
    path = "/root/.oci/terraform.tfstate"
  }
}

provider "oci" {
  config_file_profile = "DEFAULT"
}