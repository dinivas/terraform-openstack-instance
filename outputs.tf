output "ids" {
  description = "List of IDs of instances"
  value       = "${openstack_compute_instance_v2.this.*.id}"
}

output "names" {
  description = "List of instances name"
  value       = "${openstack_compute_instance_v2.this.*.name}"
}

output "network_fixed_ip_v4" {
  value = "${openstack_compute_instance_v2.this.*.network.0.fixed_ip_v4}"
}