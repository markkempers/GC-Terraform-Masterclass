resource "oci_identity_compartment" "tfdemo" {
  compartment_id = var.tenancy_ocid
  description = "Compartment for this Terraform demo" 
  name = "tf-demo"
  enable_delete = true
}