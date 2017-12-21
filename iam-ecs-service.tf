resource "aws_iam_role" "ecsServiceRole4ecs_app" {
  name = "ECS-ServiceRole-ecs_app"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceRole" {
  role       = "${aws_iam_role.ecsServiceRole4ecs_app.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "ecs_autoscale" {
  name               = "ecsAutoscaleRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_autoscale_attach" {
  name       = "ecs-autoscale-role-attach"
  roles      = ["${aws_iam_role.ecs_autoscale.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_iam_role" "EC2-Container-Service-Task-Role" {
  name = "EC2-Container-Service-Task-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ecs_permit_ssm_access" {
  statement {
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
    ]

    resources = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/${var.application_name}/*"]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "ecs_permit_ssm_read_access" {
  name   = "ecs_permit_ssm_read_access"
  path   = "/"
  policy = "${data.aws_iam_policy_document.ecs_permit_ssm_access.json}"
}

resource "aws_iam_role_policy_attachment" "EC2-Container-Service-Task-Role-PermitSSM" {
  role       = "${aws_iam_role.EC2-Container-Service-Task-Role.name}"
  policy_arn = "${aws_iam_policy.ecs_permit_ssm_read_access.arn}"
}
