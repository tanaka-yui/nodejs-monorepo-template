variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = map(string)

  default = {
    public_a  = ""
    public_c  = ""
    private_a = ""
    private_c = ""
    isolated_a = ""
    isolated_c = ""
  }
}
