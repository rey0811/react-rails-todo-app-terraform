resource "aws_vpc" "todo_prd_vpc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "192.168.0.0/20"
  enable_dns_hostnames             = "false"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = "todo-prd-vpc"
  }

  tags_all = {
    Name = "todo-prd-vpc"
  }
}

resource "aws_subnet" "todo_prd_front_sn_a" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "192.168.2.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "todo-prd-front-sn-a"
  }

  tags_all = {
    Name = "todo-prd-front-sn-a"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_subnet" "todo_prd_front_sn_c" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "192.168.3.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "todo-prd-front-sn-c"
  }

  tags_all = {
    Name = "todo-prd-front-sn-c"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_subnet" "todo_prd_app_sn_a" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "192.168.4.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "todo-prd-app-sn-a"
  }

  tags_all = {
    Name = "todo-prd-app-sn-a"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_subnet" "todo_prd_app_sn_c" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "192.168.5.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "todo-prd-app-sn-c"
  }

  tags_all = {
    Name = "todo-prd-app-sn-c"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_subnet" "todo_prd_db_sn_a" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "192.168.6.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "todo-prd-db-sn-a"
  }

  tags_all = {
    Name = "todo-prd-db-sn-a"
  }
  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_subnet" "todo_prd_db_sn_c" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "192.168.7.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "todo-prd-db-sn-c"
  }

  tags_all = {
    Name = "todo-prd-db-sn-c"
  }
  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_route_table_association" "todo_prd_front_sn_a"{
  route_table_id = "${aws_route_table.todo_prd_public_rt_a.id}"
  subnet_id      = "${aws_subnet.todo_prd_front_sn_a.id}"
}

resource "aws_route_table_association" "todo_prd_front_sn_c"{
  route_table_id = "${aws_route_table.todo_prd_public_rt_c.id}"
  subnet_id      = "${aws_subnet.todo_prd_front_sn_c.id}"
}

resource "aws_route_table_association" "todo_prd_app_sn_a"{
  route_table_id = "${aws_route_table.todo_prd_private_rt_a.id}"
  subnet_id      = "${aws_subnet.todo_prd_app_sn_a.id}"
}

resource "aws_route_table_association" "todo_prd_app_sn_c"{
  route_table_id = "${aws_route_table.todo_prd_private_rt_c.id}"
  subnet_id      = "${aws_subnet.todo_prd_app_sn_c.id}"
}

resource "aws_route_table_association" "todo_prd_db_sn_a"{
  route_table_id = "${aws_route_table.todo_prd_private_rt_a.id}"
  subnet_id      = "${aws_subnet.todo_prd_db_sn_a.id}"
}

resource "aws_route_table_association" "todo_prd_db_sn_c"{
  route_table_id = "${aws_route_table.todo_prd_private_rt_c.id}"
  subnet_id      = "${aws_subnet.todo_prd_db_sn_c.id}"
}

resource "aws_internet_gateway" "todo_prd_igw" {
  tags = {
    Name = "todo-prd-igw"
  }

  tags_all = {
    Name = "todo-prd-igw"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_nat_gateway" "todo_prd_ngw_a" {
  allocation_id     = "eipalloc-07b7c07d0e269bbf5"
  connectivity_type = "public"
  subnet_id         = "${aws_subnet.todo_prd_front_sn_a.id}"

  tags = {
    Name = "todo-prd-ngw-a"
  }

  tags_all = {
    Name = "todo-prd-ngw-a"
  }
}

resource "aws_nat_gateway" "todo_prd_ngw_c" {
  allocation_id     = "eipalloc-08922100fbd780192"
  connectivity_type = "public"
  subnet_id         = "${aws_subnet.todo_prd_front_sn_c.id}"

  tags = {
    Name = "todo-prd-ngw-c"
  }

  tags_all = {
    Name = "todo-prd-ngw-c"
  }
}

resource "aws_route_table" "todo_prd_public_rt_a" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.todo_prd_igw.id}"
  }

  tags = {
    Name = "todo-prd-public-rt-a"
  }

  tags_all = {
    Name = "todo-prd-public-rt-a"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_route_table" "todo_prd_public_rt_c" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.todo_prd_igw.id}"
  }

  tags = {
    Name = "todo-prd-public-rt-c"
  }

  tags_all = {
    Name = "todo-prd-public-rt-c"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_route_table" "todo_prd_private_rt_a" {
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.todo_prd_ngw_a.id}"
  }

  tags = {
    Name = "todo-prd-private-rt-a"
  }

  tags_all = {
    Name = "todo-prd-private-rt-a"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_route_table" "todo_prd_private_rt_c" {
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.todo_prd_ngw_c.id}"
  }

  tags = {
    Name = "todo-prd-private-rt-c"
  }

  tags_all = {
    Name = "todo-prd-private-rt-c"
  }

  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_security_group" "todo_bastion_sg" {
  description = "todo-bastion-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  name   = "todo-bastion-sg"
  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_security_group" "todo_prd_front_sg" {
  description = "ALB access from CloudFront"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ALB access from CloudFront"
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  name   = "todo-prd-front-sg"
  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_security_group" "todo_prd_app_sg" {
  description = "ECS access from ALB"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "3000"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.todo_prd_front_sg.id}"]
    self            = "false"
    to_port         = "3000"
  }

  name   = "todo-prd-app-sg"
  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}

resource "aws_security_group" "todo_prd_db_sg" {
  description = "todo-prd-db-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    description     = "RDS access from ECS"
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.todo_prd_app_sg.id}"]
    self            = "false"
    to_port         = "3306"
  }

  ingress {
    description     = "RDS access from bastion"
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.todo_bastion_sg.id}"]
    self            = "false"
    to_port         = "3306"
  }

  name   = "todo-prd-db-sg"
  vpc_id = "${aws_vpc.todo_prd_vpc.id}"
}
