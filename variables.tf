variable "enabled" {
  type    = "string"
  default = "1"
}

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

variable "network_ids" {
  type        = "list"
  default     = []
  description = "IDs of the networks to attach instance to"
}

variable "subnet_ids" {
  type        = "list"
  default     = []
  description = "IDs of the networks subnet to attach instance to"
}

variable "instance_security_group_name" {
  type        = "string"
  description = "Security group to create and associate to instance"
  default     = ""
}

variable "instance_security_group_rules" {
  type        = list(map(any))
  default     = []
  description = "The definition os security groups to associate to instance. Only one is allowed"
}

variable "security_groups_to_associate" {
  type        = list(string)
  default     = []
  description = "List of existing security groups to associate to instance."
}

variable "metadata" {
  description = "A map of metadata to add to all resources supporting it."
  default     = {}
}
