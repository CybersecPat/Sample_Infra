#this Terraform plan creates a new Windows server on a Linux KVM host

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "vm_storage" {
  name = "vm_storage"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_volume" "windows2022_qcow2" {
  name   = "windows2022.qcow2"
  pool   = libvirt_pool.vm_storage.name
  source = "/path/to/your/windows2022.iso"
  format = "qcow2"
}

resource "libvirt_domain" "windows2022_vm" {
  name   = "windows2022"
  memory = "4096"
  vcpu   = 2

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.windows2022_qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
#Replace "/path/to/your/windows2022.iso" with the path to your Windows Server 2022 ISO file.