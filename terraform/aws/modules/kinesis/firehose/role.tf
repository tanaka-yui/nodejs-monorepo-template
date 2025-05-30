resource "aws_iam_role" "firehose_role" {
  name               = "${var.name}-firehose-role"
  assume_role_policy = file("${path.module}/json/firehose-assume-policy.json")
}

resource "aws_iam_role_policy" "firehose_role_policy" {
  name = "${var.name}-firehose-role-policy"
  role = aws_iam_role.firehose_role.id
  policy = templatefile("${path.module}/json/firehose-policy.json.tpl", {
    bucket_arn  = aws_s3_bucket.s3_bucket.arn
    account_id  = var.account_id
    region      = var.region
    stream_name = var.name
  })

  depends_on = [
    aws_iam_role.firehose_role,
    aws_s3_bucket.s3_bucket
  ]
}
