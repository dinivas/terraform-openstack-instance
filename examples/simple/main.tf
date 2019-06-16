

resource "openstack_compute_keypair_v2" "keypair" {
  name = "my-keypair"
}
module "compute" {
  source              = "../../"
  instance_name       = "BLUE"
  instance_count      = 2
  image_name          = "cirros"
  flavor_name         = "m1.tiny"
  keypair             = "${openstack_compute_keypair_v2.keypair.name}"
  network_ids        = ["${openstack_compute_keypair_v2.keypair.id}"]
  subnet_ids           = ["${module.mgmt_network.subnet_ids}"]
  security_group_name  = "${var.project_name}-sg"
  security_group_rules = "${var.bastion_security_group_rules}"
}
