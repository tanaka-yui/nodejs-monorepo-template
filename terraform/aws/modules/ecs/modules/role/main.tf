resource "aws_iam_role" "execution_role" {
  name               = "${var.name}-ecs-task-execution"
  assume_role_policy = file("${path.module}/assume-role.json")
}

resource "aws_iam_role_policy" "execution_role" {
  role   = aws_iam_role.execution_role.id
  policy = var.execution_role_policy
}

resource "aws_iam_role" "task_role" {
  name               = "${var.name}-ecs-task"
  assume_role_policy = file("${path.module}/assume-role.json")
}

resource "aws_iam_role_policy" "task_role" {
  role   = aws_iam_role.task_role.id
  policy = var.task_role_policy
}