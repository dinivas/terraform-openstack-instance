data "openstack_compute_flavor_v2" "this" {
  name = "${var.flavor_name}"
}

data "openstack_images_image_v2" "this" {
  name        = "${var.image_name}"
  most_recent = true
}

data "openstack_networking_network_v2" "this" {
  name = "${var.network_name}"
}

data "openstack_networking_secgroup_v2" "this" {
  count = "${length(var.security_group_names)}"

  name = "${var.security_group_names[count.index]}"
}

resource "openstack_compute_instance_v2" "this" {
  count = "${var.instance_count}"

  name       = "${var.instance_name}-${count.index}"
  image_name = "${data.openstack_images_image_v2.this.name}"
  flavor_id  = "${data.openstack_compute_flavor_v2.this.id}"
  key_pair   = "${var.keypair}"

  network {
    port = "${openstack_networking_port_v2.this.*.id[count.index]}"
  }
}

resource "openstack_networking_port_v2" "this" {
  count = "${var.instance_count}"

  name               = "${var.network_name}-port-${count.index}"
  network_id         = "${data.openstack_networking_network_v2.this.id}"
  admin_state_up     = "true"
  security_group_ids = ["${data.openstack_networking_secgroup_v2.this.*.id}"]
}

# resource "openstack_compute_interface_attach_v2" "this" {
#   count = "${var.instance_count}"


#   instance_id = "${openstack_compute_instance_v2.this.*.id[count.index]}"
#   port_id     = "${openstack_networking_port_v2.this.*.id[count.index]}"
# }

