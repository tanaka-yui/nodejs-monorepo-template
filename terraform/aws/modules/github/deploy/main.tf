# see: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
# see: https://github.com/aws-actions/configure-aws-credentials/issues/357#issuecomment-1011642085
data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # ref: https://qiita.com/minamijoyo/items/eac99e4b1ca0926c4310
  # ref: https://zenn.dev/yukin01/articles/github-actions-oidc-provider-terraform
  # ref: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
  # ref: https://github.com/aws-actions/configure-aws-credentials/issues/357
  thumbprint_list = distinct(
    concat(
      ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"],
      [for certificate in data.tls_certificate.github_actions.certificates : certificate.sha1_fingerprint],
    )
  )
}

locals {
  full_paths = [
    for repo in var.allowed_repositories : "repo:${var.organization_name}/${repo}:*"
  ]
}

# see: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy
data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.full_paths
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions.json
  description        = "IAM Role for GitHub Actions OIDC"
}

resource "aws_iam_policy" "s3" {
  name   = "github-actions-s3-policy"
  policy = file("${path.module}/policy/s3-policy.json")
}

resource "aws_iam_policy" "cf" {
  name = "github-actions-cf-policy"
  policy = templatefile("${path.module}/policy/cf-policy.json", {
    account_id = var.account_id
  })
}

resource "aws_iam_policy" "ecs" {
  name   = "github-actions-ecs-policy"
  policy = file("${path.module}/policy/ecs-policy.json")
}

resource "aws_iam_policy" "ssm" {
  name   = "github-actions-ssm-policy"
  policy = file("${path.module}/policy/ssm-policy.json")
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.github_actions.name
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = aws_iam_policy.s3.arn
  role       = aws_iam_role.github_actions.name
}

resource "aws_iam_role_policy_attachment" "cf" {
  policy_arn = aws_iam_policy.cf.arn
  role       = aws_iam_role.github_actions.name
}

resource "aws_iam_role_policy_attachment" "ecs" {
  policy_arn = aws_iam_policy.ecs.arn
  role       = aws_iam_role.github_actions.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = aws_iam_policy.ssm.arn
  role       = aws_iam_role.github_actions.name
}