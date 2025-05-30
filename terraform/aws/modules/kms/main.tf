resource "aws_kms_key" "key" {}

resource "aws_kms_alias" "key" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.key.key_id
}