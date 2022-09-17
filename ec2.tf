resource "aws_instance" "todo_bastion" {
  ami                         = "ami-0f36dcfcc94112ea1"
  associate_public_ip_address = "false"
  availability_zone           = "ap-northeast-1a"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_core_count       = "1"
  cpu_threads_per_core = "2"

  credit_specification {
    cpu_credits = "unlimited"
  }

  disable_api_stop        = "false"
  disable_api_termination = "true"
  ebs_optimized           = "true"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = "${aws_iam_instance_profile.todo_ec2_role.name}"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  ipv6_address_count                   = "0"
  key_name                             = "${var.ec2_keypair}"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }

  monitoring = "false"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "true"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    volume_size           = "8"
    volume_type           = "gp2"
  }

  source_dest_check = "true"
  subnet_id         = "${aws_subnet.todo_prd_app_sn_a.id}"

  tags = {
    Name = "todo-bastion"
  }

  tags_all = {
    Name = "todo-bastion"
  }

  tenancy                = "default"
  vpc_security_group_ids = ["${aws_security_group.todo_bastion_sg.id}"]
}

resource "aws_iam_instance_profile" "todo_ec2_role" {
  name = "todo_ec2_role"
  role = "${aws_iam_role.todo_ec2_role.name}"
}
