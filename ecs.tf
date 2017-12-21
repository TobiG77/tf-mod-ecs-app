resource "aws_ecs_cluster" "ecs_app" {
  name = "${var.application_name}"
}

resource "aws_ecs_task_definition" "ecs_app" {
  family = "${var.application_name}"

  task_role_arn = "${aws_iam_role.EC2-Container-Service-Task-Role.arn}"

  container_definitions = <<CONTAINER_DEF
  [
  {
    "name": "${var.application_name}",
    "image": "${aws_ecr_repository.ecs_app.repository_url}:latest",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "links": [],
    "portMappings": [
      {
        "containerPort": ${var.application_port},
        "hostPort": ${var.application_port},
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "entryPoint": [],
    "command": [],
    "environment": [
      {
        "name": "AWS_REGION",
        "value": "${var.region}"
      },
      {
        "name": "ENVIRONMENT",
        "value": "${var.environment}"
      }
    ],
   "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "/aws/ecs/${var.application_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "docker"
        }
    },
    "mountPoints": [],
    "volumesFrom": []
  }
]
CONTAINER_DEF
}

resource "aws_ecs_service" "ecs_app" {
  name            = "${var.application_name}"
  cluster         = "${aws_ecs_cluster.ecs_app.id}"
  task_definition = "${aws_ecs_task_definition.ecs_app.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecsServiceRole4ecs_app.arn}"

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "${var.application_name}"
    container_port   = "${var.application_port}"
  }
}

resource "aws_appautoscaling_target" "ecs_app" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_app.name}/${aws_ecs_service.ecs_app.name}"
  role_arn           = "${aws_iam_role.ecs_autoscale.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_ecr_repository" "ecs_app" {
  name = "${var.application_name}"
}

resource "aws_cloudwatch_log_group" "ecs_app-docker-instances" {
  name              = "/aws/ecs/${var.application_name}"
  retention_in_days = 14

  tags {
    Application = "${var.application_name}"
  }
}
