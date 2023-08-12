provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "vm_storage" {
  name = "vm_storage"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_volume" "ubuntu2204_qcow2" {
  name   = "ubuntu2204.qcow2"
  pool   = libvirt_pool.vm_storage.name
  source = "/path/to/your/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_domain" "ubuntu2204_vm" {
  name   = "ubuntu2204"
  memory = "2048"
  vcpu   = 1

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.ubuntu2204_qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  cloudinit = <<EOF
#cloud-config
password: yourpassword
chpasswd: { expire: False }
ssh_pwauth: True
EOF
}

#Replace "/path/to/your/ubuntu-22.04-server-cloudimg-amd64.img" with the path to your Ubuntu 22.04 cloud image. You can download the cloud image from the official Ubuntu website.