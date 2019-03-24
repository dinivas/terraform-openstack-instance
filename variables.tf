variable "instance_name" {
  type        = "string"
  description = "The name (prefix) of the compute instance to create."
}

variable "instance_count" {
  description = "Number of instances to launch"
  default     = 1
}

variable "image_name" {
  type        = "string"
  description = "The Glance image name to use."
}

variable "flavor_name" {
  type        = "string"
  default     = "m1.tiny"
  description = "The name of the flavor to use to create compute"
}

variable "keypair" {
  type        = "string"
  description = "The name of the keypair to use"
}

variable "network_name" {
  type        = "string"
  default     = ""
  description = "The name of the network to attach instance to"
}

variable "security_group_names" {
  type        = "list"
  default     = ["default"]
  description = "The name of the network to attach instance to"
}
