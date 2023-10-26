provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.my_role.arn

  container_definitions = jsonencode([
    {
      name  = "my-app",
      image = "Devops:My-nginx-image", # Replace with your Docker Hub image
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
        },
      ],
      environment = [
        {
          name  = "APIKEY",
          value = "1997-07-16T00:00:00Z",
        },
      ],
    },
  ])
}

resource "aws_iam_role" "my_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}
