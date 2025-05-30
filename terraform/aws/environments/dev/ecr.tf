module "ecr_fluent_bit" {
  source = "../../modules/ecr"

  name = local.name_fluent_bit
}

module "ecr_api" {
  source = "../../modules/ecr"

  name = local.name_api
}
