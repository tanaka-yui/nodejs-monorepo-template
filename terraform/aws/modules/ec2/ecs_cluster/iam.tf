resource "aws_iam_role" "this" {
  name               = var.cluster_name
  assume_role_policy = file("${path.module}/role/assume-role.json")
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

  depends_on = [aws_iam_role.this]
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  depends_on = [aws_iam_role.this]
}

resource "aws_iam_role_policy" "s3" {
  count = var.mount_s3_bucket_arn == "" ? 0 : 1
  role  = aws_iam_role.this.id
  policy = templatefile("${path.module}/role/s3_policy.json", {
    bucket_arn = var.mount_s3_bucket_arn
  })

  depends_on = [aws_iam_role.this]
}

resource "aws_iam_instance_profile" "this" {
  name = var.cluster_name
  role = aws_iam_role.this.name

  depends_on = [aws_iam_role.this]
}
