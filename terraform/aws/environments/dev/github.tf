module "github_oidc" {
  source = "../../modules/github/admin"

  account_id           = local.account_id
  organization_name    = "tanaka-yui"
  allowed_repositories = ["nodejs-monorepo-template"]
}
