provider "vsphere" {
  vsphere_server       = "${var.vsphere_server}"
  user                 = "${var.vsphere_user}"
  password             = "${var.vsphere_pass}"
  
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name          = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "ws2019-vm" {
  name                 = "${var.vm_name}"
  folder               = "${var.vm_folder}"
  num_cpus             = "${var.vm_cpu}"
  memory               = "${var.vm_memory}"
  datastore_id         = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id     = "${data.vsphere_resource_pool.pool.id}"
  guest_id             = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type            = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
  
  clone {
    template_uuid    = "${data.vsphere_virtual_machine.template.id}"

    customize {
      windows_options {
        computer_name   = "${var.vm_name}"
        admin_password  = "${var.vm_admin_pass}"
        auto_logon      = true
      }
      # Using DHCP  
      network_interface {}
      
      # Increase timeout to avoid being considered as an error (in minutes)
      timeout = 30
    }
  }
  
  provisioner "file" {
    connection  = {
      type      = "winrm"
      user      = "Administrator"
      password  = "${var.vm_admin_pass}"
      agent     = "false"
    }
    source      = "${path.module}/active-directory/install-ad.ps1"
    destination = "C:\\Windows\\Temp\\active-directory\\install-ad.ps1"
  }
  
  provisioner"remote-exec" {
    connection = {
      type      = "winrm"
      user      = "Administrator"
      password  = "${var.vm_admin_pass}"
      agent     = "false"
    }
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File C:\\Windows\\Temp\\active-directory\\install-ad.ps1"
    ]
  }
}
