data "openstack_compute_flavor_v2" "this" {
  count = "${var.enabled}"

  name = "${var.flavor_name}"
}

data "openstack_images_image_v2" "this" {
  count = "${var.enabled}"

  name        = "${var.image_name}"
  most_recent = true
}

resource "openstack_networking_secgroup_v2" "this" {
  count = "${var.instance_security_group_name != "" ? var.enabled * 1 : 0}"

  name        = "${var.instance_security_group_name}"
  description = "${format("Instance %s %s %s", var.instance_name, var.instance_security_group_name, "security group")}"
}

resource "openstack_networking_secgroup_rule_v2" "this" {
  count = "${(var.instance_security_group_name != "" && length(var.instance_security_group_rules) > 0) ? var.enabled * length(var.instance_security_group_rules) : 0}"

  port_range_min    = "${lookup(var.instance_security_group_rules[count.index], "port_range_min", 0)}"
  port_range_max    = "${lookup(var.instance_security_group_rules[count.index], "port_range_max", 0)}"
  protocol          = "${lookup(var.instance_security_group_rules[count.index], "protocol")}"
  direction         = "${lookup(var.instance_security_group_rules[count.index], "direction")}"
  ethertype         = "${lookup(var.instance_security_group_rules[count.index], "ethertype")}"
  remote_ip_prefix  = "${lookup(var.instance_security_group_rules[count.index], "remote_ip_prefix", "")}"
  security_group_id = "${element(openstack_networking_secgroup_v2.this.*.id, count.index)}"
}

# This trigger wait for subnet defined outside of this module to be created
resource "null_resource" "network_subnet_found" {
  count = "${length(var.subnet_ids) * var.enabled}"

  triggers = {
    subnet = "${var.subnet_ids[count.index][0]}"
  }
}

resource "openstack_compute_instance_v2" "this" {
  count = "${var.instance_count * var.enabled}"

  depends_on = ["null_resource.network_subnet_found"]

  name                = "${format("%s-%s", var.instance_name, count.index)}"
  image_name          = "${data.openstack_images_image_v2.this.0.name}"
  flavor_id           = "${data.openstack_compute_flavor_v2.this.0.id}"
  key_pair            = "${var.keypair}"
  security_groups     = "${concat(openstack_networking_secgroup_v2.this.*.name, var.security_groups_to_associate)}"
  stop_before_destroy = "${var.stop_before_destroy}"

  dynamic "network" {
    for_each = var.network_ids

    content {
      uuid = network.value
    }
  }

  metadata  = "${var.metadata}"
  user_data = "${var.user_data}"

  availability_zone = "${var.availability_zone}"

  connection {
    type        = "ssh"
    user        = "centos"
    port        = 22
    host        = "${element(openstack_compute_instance_v2.this.*.access_ip_v4, count.index)}"
    private_key = "${lookup(var.ssh_via_bastion_config, "host_private_key")}"
    agent       = false

    bastion_host        = "${lookup(var.ssh_via_bastion_config, "bastion_host")}"
    bastion_port        = 22
    bastion_user        = "centos"
    bastion_private_key = "${lookup(var.ssh_via_bastion_config, "bastion_private_key")}"
  }

  provisioner "remote-exec" {
    when = "destroy"
    inline = [
      "${var.execute_on_destroy_instance_script}",
    ]
    on_failure = "continue"
  }
}

# resource "null_resource" "instance_destroy_hook" {
#   count = "${var.execute_on_destroy_instance_script != "" ? var.instance_count * var.enabled : 0}"

#   depends_on = ["null_resource.network_subnet_found", "${element(openstack_compute_instance_v2.this.*.id, count.index)}"]

#   # Changes to any instance that requires destroy_hook
#   triggers = {
#     module_instance_id = "${element(openstack_compute_instance_v2.this.*.id, count.index)}"
#   }
# }

# resource "openstack_compute_interface_attach_v2" "this" {
#   count = "${var.instance_count}"


#   instance_id = "${openstack_compute_instance_v2.this.*.id[count.index]}"
#   network_id     = "${var.network_id}"
# }
