resource "aws_ecr_repository" "todo_prd_rails" {
  force_delete = true
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "false"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "todo-prd-rails"
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "$(aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com)"
  }

  provisioner "local-exec" {
    command = "docker build -t todo-prd-rails ${var.docker_dir}"
  }

  provisioner "local-exec" {
    command = "docker tag todo-prd-rails:latest ${aws_ecr_repository.todo_prd_rails.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.todo_prd_rails.repository_url}"
  }
}
