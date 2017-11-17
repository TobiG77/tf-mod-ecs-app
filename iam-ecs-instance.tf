resource "aws_iam_instance_profile" "ecs-instance-ecs_app" {
  name = "ecs-instance-ecs_app"
  role = "${aws_iam_role.ecs-instance-ecs_app.name}"
}

resource "aws_iam_role" "ecs-instance-ecs_app" {
  name = "ECS-InstanceRole-${var.application_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-Instance-AmazonEC2ContainerServiceforEC2Role" {
  role       = "${aws_iam_role.ecs-instance-ecs_app.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "ecs_permit_cloudwatch_log_write" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/${var.application_name}*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/${var.application_name}/",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/${var.application_name}/*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "ecs_permit_cloudwatch_log_write" {
  name   = "ecs_permit_cloudwatch_log_write"
  path   = "/"
  policy = "${data.aws_iam_policy_document.ecs_permit_cloudwatch_log_write.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_permit_cloudwatch_log_write" {
  role       = "${aws_iam_role.ecs-instance-ecs_app.name}"
  policy_arn = "${aws_iam_policy.ecs_permit_cloudwatch_log_write.arn}"
}
