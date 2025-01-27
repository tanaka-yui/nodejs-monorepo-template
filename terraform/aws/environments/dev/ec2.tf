module "ec2-ssm-proxy" {
  source = "../../modules/ec2/ssm-proxy"

  name      = local.env
  vpc_id    = module.vpc-standard.vpc_id
  subnet_id = module.vpc-standard.subnet_private_a.id
}
