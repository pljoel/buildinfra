variable "vsphere_server" {
  type = "string"
  description = "vSphere FQDN or IP"
}
variable "vsphere_user" {
  type = "string"
  description = "vSphere user"
}
variable "vsphere_pass" {
  type = "string"
  description = "vSphere password"
}

variable "vsphere_datacenter" {
  type = "string"
  description = "vSphere datacenter to create the plan to"
}
variable "vsphere_datastore" {
  type = "string"
  description = "vSphere datastore to create the plan to"
}
variable "vsphere_pool" {
  type = "string"
  description = <<EOF
vSphere resource pool.
  If you don't have a cluster, it's going to be your ESXi host with /Resources/
  Eg: 192.168.0.10/Resources
EOF
}
variable "vsphere_network" {
  type = "string"
  description = "Name of the network"
  default = "VM Network"
}
variable "vsphere_template" {
  type = "string"
  description = "Name of the VM template to create from"
}

variable "vm_name" {
  type = "string"
  description = "Name of the VM to create"
}
variable "vm_admin_pass" {
  type = "string"
  description = "Windows administrator password"
}
variable "vm_folder" {
  type = "string"
  description = "The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in"
}
variable "vm_cpu" {
  type = "string"
  description = "Number of vCPUs"
  default = "2"
}
variable "vm_memory" {
  type = "string"
  description = "RAM (in MB)"
  default = "4096"
}
