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
  type        = list
  default     = []
  description = "IDs of the networks to attach instance to"
}

variable "subnet_ids" {
  type        = list
  default     = []
  description = "IDs of the networks subnet to attach instance to"
}

variable "security_group_name" {
  type= "string"
}

variable "security_group_rules" {
  type        = list(map(any))
  default     = []
  description = "The definition os security groups to associate to instance. Only one is allowed"
}
