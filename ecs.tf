resource "aws_ecs_cluster" "todo_prd_ecs_cluster" {
  name = "todo-prd-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "todo_prd_api_service" {
  cluster = aws_ecs_cluster.todo_prd_ecs_cluster.arn

  deployment_circuit_breaker {
    enable   = "false"
    rollback = "false"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = "100"
  deployment_minimum_healthy_percent = "50"
  desired_count                      = "1"
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "true"
  health_check_grace_period_seconds  = "7200"
  launch_type                        = "FARGATE"

  load_balancer {
    container_name   = "todo-api-container"
    container_port   = "3000"
    target_group_arn = aws_lb_target_group.todo_prd_api_tg.arn
  }

  name = "todo-prd-api-service"

  network_configuration {
    assign_public_ip = "false"
    security_groups  = ["${aws_security_group.todo_prd_app_sg.id}"]
    subnets          = ["${aws_subnet.todo_prd_app_sn_a.id}", "${aws_subnet.todo_prd_app_sn_c.id}"]
  }

  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  task_definition     = aws_ecs_task_definition.todo_api_task.arn
}

resource "aws_ecs_task_definition" "todo_api_task" {
  container_definitions    = "[{\"cpu\":0,\"environment\":[{\"name\":\"RAILS_ENV\",\"value\":\"production\"},{\"name\":\"RAILS_LOG_TO_STDOUT\",\"value\":\"true\"}],\"essential\":true,\"healthCheck\":{\"command\":[\"CMD-SHELL\",\"curl -f http://localhost:3000/api/v1/health_check || exit 1\"],\"interval\":5,\"retries\":5,\"startPeriod\":300,\"timeout\":2},\"image\":\"${aws_ecr_repository.todo_prd_rails.repository_url}:latest\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/todo-api-task\",\"awslogs-region\":\"ap-northeast-1\",\"awslogs-stream-prefix\":\"ecs\"}},\"mountPoints\":[],\"name\":\"todo-api-container\",\"portMappings\":[{\"containerPort\":3000,\"hostPort\":3000,\"protocol\":\"tcp\"}],\"secrets\":[{\"name\":\"DATABASE_URL\",\"valueFrom\":\"todo_app_database_url\"},{\"name\":\"RAILS_MASTER_KEY\",\"valueFrom\":\"todo_app_rails_master_key\"}],\"volumesFrom\":[]}]"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.todo_ecs_task_execution_role.arn
  family                   = "todo-api-task"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.todo_ecs_task_role.arn

}
