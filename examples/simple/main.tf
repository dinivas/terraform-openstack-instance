

resource "openstack_compute_keypair_v2" "keypair" {
  name = "my-keypair"
}

module "mgmt_network" {
  #source              = "../terraform-os-network/"
  source              = "github.com/dinivas/terraform-openstack-network"
  network_name        = "test-mgmt"
  network_tags        = ["test", "management", "dinivas"]
  network_description = ""

  subnets = [
    {
      subnet_name       = "test-mgmt-subnet"
      subnet_cidr       = "10.10.17.1/24"
      subnet_ip_version = 4
      subnet_tags       = "test, management, dinivas"
    }
  ]
}
module "compute" {
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
