resource "aws_ecs_cluster" "demo" {
  name = "${var.ecs_cluster_name}-cluster"
}

data "template_file" "app" {
  template = file("templates/fastapi_app.json.tpl")

  vars = {
    docker_image_url_fastapi = var.docker_image_url_fastapi
    region                   = var.region
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "fastapi-app"
  network_mode             = "awsvpc" # Required for Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn            = aws_iam_role.ecs-task-execution-role.arn
  container_definitions    = data.template_file.app.rendered
}

resource "aws_ecs_service" "demo" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.demo.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = var.app_count
  network_configuration {
    subnets          = [aws_subnet.public-1.id, aws_subnet.public-2.id]
    security_groups  = [aws_security_group.ecs-fargate.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "fastapi-app"
    container_port   = 8000
  }
}
