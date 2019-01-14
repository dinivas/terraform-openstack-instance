output "ids" {
  description = "List of IDs of instances"
  value       = "${openstack_compute_instance_v2.this.*.id}"
}

output "names" {
  description = "List of IDs of instances"
  value       = "${openstack_compute_instance_v2.this.*.name}"
}