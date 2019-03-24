

resource "openstack_compute_keypair_v2" "keypair" {
  name = "my-keypair"
}
module "compute" {
  source               = "../../"
  instance_name        = "BLUE"
  instance_count       = 2
  image_name           = "cirros"
  flavor_name          = "m1.tiny"
  keypair              = "${openstack_compute_keypair_v2.keypair.name}"
  network_name         = "my-network"
  security_group_names = ["default"]
}
