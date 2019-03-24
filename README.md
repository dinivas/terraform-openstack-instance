# Terraform module for Openstack Instance

This module create an Openstack instance

## Usage

```
resource "openstack_compute_keypair_v2" "keypair" {
  name = "my-keypair"
}
module "compute" {
  source               = "shepherdcloud/instance/openstack"
  instance_name        = "BLUE"
  instance_count       = 2
  image_name           = "cirros"
  flavor_name          = "m1.tiny"
  keypair              = "${openstack_compute_keypair_v2.keypair.name}"
  network_name         = "my-network"
  security_group_names = ["default"]
}
```

## Scenarios

Provide advanced use cases here.

## Examples

Paste the links to your sample code in `examples` folder.

## Inputs

List all input variables of your module.

## Outputs

List all output variables of your module.