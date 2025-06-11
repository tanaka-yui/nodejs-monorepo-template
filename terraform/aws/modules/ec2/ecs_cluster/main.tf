# ECSコンテナ最適化AMIについて
# https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs-optimized_AMI.html

# 安定している最新の Amazon ECS-optimized AMI メタデータを取得する
# コマンドから確認する場合
# aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2023/neuron/recommended --region ap-northeast-1
# AWSコンソールから確認する場合
# https://ap-northeast-1.console.aws.amazon.com/systems-manager/parameters/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id/description?region=ap-northeast-1#
data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# https://ap-northeast-1.console.aws.amazon.com/systems-manager/parameters/aws/service/ecs/optimized-ami/amazon-linux-2/kernel-5.10/gpu/recommended/image_id/description?region=ap-northeast-1
data "aws_ssm_parameter" "ecs_gpu_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/kernel-5.10/gpu/recommended/image_id"
}

resource "aws_launch_template" "this" {
  name = var.cluster_name

  image_id = var.image_id == "" ? data.aws_ssm_parameter.ecs_gpu_ami_id.value : var.image_id

  instance_type = var.instance_type

  dynamic "instance_market_options" {
    for_each = var.use_spot ? [1] : []
    content {
      market_type = "spot"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = var.private_subnet_ids[0]
    security_groups             = [aws_security_group.this.id]
  }

  tags = {
    Name = var.cluster_name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name       = var.cluster_name
      PatchGroup = var.cluster_name
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.ebs_root != null ? [1] : []
    content {
      device_name = "/dev/xvda"
      ebs {
        delete_on_termination = var.ebs_root.delete_on_termination
        encrypted             = var.ebs_root.encrypted
        volume_size           = var.ebs_root.volume_size
        volume_type           = var.ebs_root.volume_type
      }
    }
  }

  user_data = base64encode(var.user_data == null ? templatefile("${path.module}/file/user_data.sh", {
    cluster_name = var.cluster_name
    gpu_support  = var.gpu_support
  }) : var.user_data)

  lifecycle {
    ignore_changes = [image_id]
  }

  depends_on = [
    aws_iam_instance_profile.this,
    aws_security_group.this
  ]
}

