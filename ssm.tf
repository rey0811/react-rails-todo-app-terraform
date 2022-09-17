resource "aws_ssm_parameter" "todo_app_database_url" {
  arn       = "arn:aws:ssm:ap-northeast-1:${local.account_id}:parameter/todo_app_database_url"
  data_type = "text"
  name      = "todo_app_database_url"
  tier      = "Standard"
  type      = "String"
  value     = "${var.todo_app_database_url}"
}

resource "aws_ssm_parameter" "todo_app_rails_master_key" {
  arn       = "arn:aws:ssm:ap-northeast-1:${local.account_id}:parameter/todo_app_rails_master_key"
  data_type = "text"
  name      = "todo_app_rails_master_key"
  tier      = "Standard"
  type      = "String"
  value     = "${var.todo_app_rails_master_key}"
}
