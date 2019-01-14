module "compute" {
  source         = "../../"
  compute_name   = "BLUE"
  instance_count = 2
  image_name     = "cirros"
  flavor_name    = "m1.tiny"
  keypair = "shepherd"
}
