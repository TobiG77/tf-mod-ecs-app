output "repository_url" {
  value = "${aws_ecr_repository.ecs_app.repository_url}"
}

output "cluster_name" {
  value = "${aws_ecs_service.ecs_app.name}"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.ecs-instance-ecs_app.name}"
}

output "task_definition_arn" {
  value = "${aws_ecs_task_definition.ecs_app.arn}"
}

output "task_definition_family" {
  value = "${aws_ecs_task_definition.ecs_app.family}"
}
