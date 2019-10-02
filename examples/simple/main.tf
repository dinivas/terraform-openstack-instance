

resource "openstack_compute_keypair_v2" "keypair" {
  name = "my-keypair"
}


module "network" {
  source              = "github.com/dinivas/terraform-openstack-network"
  network_name        = "my-network"
  network_tags        = ["management", "dinivas"]
  network_description = "My network description"

  subnets = [
    {
      subnet_name       = "my-network-subnet"
      subnet_cidr       = "10.10.14.0/24"
      subnet_ip_version = 4
      subnet_tags       = "management, dinivas"
    }
  ]
}

module "compute1" {
  source                       = "../../"
  instance_name                = "BLUE"
  instance_count               = 1
  image_name                   = "cirros"
  flavor_name                  = "m1.tiny"
  keypair                      = "${openstack_compute_keypair_v2.keypair.name}"
  network_ids                  = ["${module.network.network_id}"]
  subnet_ids                   = ["${module.network.subnet_ids}"]
  instance_security_group_name = "BLUE-sg"
  instance_security_group_rules = [
    {
      direction        = "ingress"
      ethertype        = "IPv4"
      protocol         = "tcp"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = ""
  }]
  enabled = "1"
  availability_zone = "nova:node03"
}


module "compute2" {
  source                       = "../../"
  instance_name                = "GREEN"
  instance_count               = 1
  image_name                   = "cirros"
  flavor_name                  = "m1.tiny"
  keypair                      = "${openstack_compute_keypair_v2.keypair.name}"
  network_ids                  = ["${module.network.network_id}"]
  subnet_ids                   = ["${module.network.subnet_ids}"]
  instance_security_group_name = "GREEN-sg"
  instance_security_group_rules = [
    {
      direction        = "ingress"
      ethertype        = "IPv4"
      protocol         = "tcp"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = ""
  }]
  enabled = "1"
  availability_zone = "nova:node03"
}