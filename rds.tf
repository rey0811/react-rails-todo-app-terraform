resource "aws_db_subnet_group" "todo_prd_db_sn" {
  description = "todo-prd-db-sn"
  name        = "todo-prd-db-sn"
  subnet_ids  = ["${aws_subnet.todo_prd_db_sn_a.id}", "${aws_subnet.todo_prd_db_sn_c.id}"]
}

resource "aws_rds_cluster" "todo_prd_db" {
  enable_global_write_forwarding      = false
  skip_final_snapshot                 = true
  tags                                = {}
  apply_immediately                   = false
  backtrack_window                    = "0"
  backup_retention_period             = "1"
  cluster_identifier                  = "todo-prd-db"
  cluster_members                     = ["todo-prd-db-instance-1"]
  copy_tags_to_snapshot               = "true"
  database_name                       = "todo"
  db_cluster_parameter_group_name     = "default.aurora-mysql5.7"
  db_subnet_group_name                = "${aws_db_subnet_group.todo_prd_db_sn.id}"
  deletion_protection                 = "false"
  enable_http_endpoint                = "false"
  engine                              = "aurora-mysql"
  engine_mode                         = "provisioned"
  engine_version                      = "5.7.mysql_aurora.2.10.2"
  iam_database_authentication_enabled = "false"
  master_username                     = "admin"
  master_password                     = "${var.rds_master_password}"
  network_type                        = "IPV4"
  port                                = "3306"
  preferred_backup_window             = "13:24-13:54"
  preferred_maintenance_window        = "tue:18:01-tue:18:31"
  storage_encrypted                   = "true"
  vpc_security_group_ids              = ["${aws_security_group.todo_prd_db_sg.id}"]
  depends_on = [aws_db_subnet_group.todo_prd_db_sn]
}

resource "aws_rds_cluster_instance" "todo_prd_db_instance_1" {
  identifier         = "todo-prd-db-instance-1"
  cluster_identifier = aws_rds_cluster.todo_prd_db.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.todo_prd_db.engine
  engine_version     = aws_rds_cluster.todo_prd_db.engine_version
  db_subnet_group_name                = "${aws_db_subnet_group.todo_prd_db_sn.id}"
}
