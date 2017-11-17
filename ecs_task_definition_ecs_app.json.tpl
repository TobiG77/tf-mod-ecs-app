[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "links": [],
    "portMappings": [
      {
        "containerPort": ${containerPort},
        "hostPort": ${hostPort},
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "entryPoint": [],
    "command": [],
    "environment": [
      {
        "name": "AWS_REGION",
        "value": "${region}"
      }
    ],
   "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "/aws/ecs/${name}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "docker"
        }
    },
    "mountPoints": [],
    "volumesFrom": []
  }
]
