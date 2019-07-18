

resource "openstack_compute_keypair_v2" "keypair" {
  name = "my-keypair"
}
module "compute" {
  source                       = "../../"
  instance_name                = "BLUE"
  instance_count               = 2
  image_name                   = "cirros"
  flavor_name                  = "m1.tiny"
  keypair                      = "${openstack_compute_keypair_v2.keypair.name}"
  network_ids                  = ["${openstack_compute_keypair_v2.keypair.id}"]
  subnet_ids                   = ["${module.mgmt_network.subnet_ids}"]
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
}
