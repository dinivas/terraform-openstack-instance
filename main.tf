data "openstack_compute_flavor_v2" "this" {
  name = "${var.flavor_name}"
}

data "openstack_images_image_v2" "this" {
  name        = "${var.image_name}"
  most_recent = true
}

resource "openstack_compute_instance_v2" "this" {
  count = "${var.instance_count}"

  name            = "${var.compute_name}-${count.index}"
  image_name      = "${data.openstack_images_image_v2.this.name}"
  flavor_id       = "${data.openstack_compute_flavor_v2.this.id}"
  key_pair        = "${var.keypair}"
}
