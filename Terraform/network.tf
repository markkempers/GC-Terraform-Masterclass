#Create VCN for Wordpress
resource "oci_core_vcn" "tfdemo" {
  compartment_id = oci_identity_compartment.tfdemo.id
  cidr_blocks = ["10.10.0.0/16"]
  display_name = "Terraform Demo VCN"
  dns_label = "tfdemo"
}

# Subnet in VCN
resource "oci_core_subnet" "inet" {
  cidr_block = "10.10.1.0/24"
  compartment_id = oci_identity_compartment.tfdemo.id
  vcn_id = oci_core_vcn.tfdemo.id
  display_name = "Subnet for Terraform Demo"
  route_table_id = oci_core_route_table.tfdemo.id
  security_list_ids = [oci_core_security_list.tfdemo.id]
}

# Create an internet gateway in default VCN
resource "oci_core_internet_gateway" "igw" {
  compartment_id = oci_identity_compartment.tfdemo.id
  vcn_id = oci_core_vcn.tfdemo.id
  display_name = "Internet Gateway"
}

# Create routing table for internet access
resource "oci_core_route_table" "tfdemo" {
  compartment_id = oci_identity_compartment.tfdemo.id
  vcn_id = oci_core_vcn.tfdemo.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  display_name = "Routingtable for Terraform Demo"
}

# Create security list for subnet
resource "oci_core_security_list" "tfdemo" {
  compartment_id = oci_identity_compartment.tfdemo.id
  vcn_id = oci_core_vcn.tfdemo.id
  display_name = "Security List for Terraform Demo"
  ingress_security_rules {
    protocol = local.tcp_protocol_number
    source = var.students_cidr
    description = "Incoming SSH Port - Student CIDR"
    tcp_options {
      min = local.ssh_port_number
      max = local.ssh_port_number
    }
  }
  egress_security_rules {
    protocol = local.all_protocols
    destination = "0.0.0.0/0"
  }
}

locals {
  ssh_port_number           = "22"
  tcp_protocol_number       = "6"
  all_protocols             = "all"
}