module "vpc-standard" {
  source   = "../../modules/vpc/base"
  name     = local.name
  vpc_cidr = "10.1.0.0/16"
  subnet_cidr = {
    public_a  = "10.1.1.0/24"
    public_c  = "10.1.2.0/24"
    private_a = "10.1.16.0/20"
    private_c = "10.1.32.0/20"
    isolated_a = "10.1.64.0/20"
    isolated_c = "10.1.80.0/20"
  }
}
