provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "./modules/vpc"
  #version = "5.0.0"  # specify the latest version

  name = "${var.project}-${var.environment}-${var.reg}-vpc01"
  cidr = var.vpc_cidr

  azs             = var.private_subnet_azs
  private_subnets = var.private_subnets

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_security_group" "sg01" {
  vpc_id = module.vpc.vpc_id

  egress { 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-sg01"
  }
}

resource "aws_network_acl" "nacl01" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = "3.5.64.0/21"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 102
    action     = "allow"
    cidr_block = "3.5.72.0/23"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 103
    action     = "allow"
    cidr_block = "52.218.0.0/17"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 104
    action     = "allow"
    cidr_block = "52.92.0.0/17"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 105
    action     = "allow"
    cidr_block = "10.5.160.0/24"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "6"
    rule_no    = 106
    action     = "allow"
    cidr_block = "192.168.1.102/32"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "6"
    rule_no    = 107
    action     = "allow"
    cidr_block = "155.136.158.8/32"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "-1"
    rule_no    = 108
    action     = "allow"
    cidr_block = "54.171.39.29/32"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = "3.5.64.0/21"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 102
    action     = "allow"
    cidr_block = "3.5.72.0/23"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 103
    action     = "allow"
    cidr_block = "52.218.0.0/17"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 104
    action     = "allow"
    cidr_block = "52.92.0.0/17"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 105
    action     = "allow"
    cidr_block = "10.5.160.0/24"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "6"
    rule_no    = 106
    action     = "allow"
    cidr_block = "192.168.1.102/32"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "6"
    rule_no    = 107
    action     = "allow"
    cidr_block = "155.136.158.8/32"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "-1"
    rule_no    = 108
    action     = "allow"
    cidr_block = "54.171.39.29/32"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-nacl01"
  }
}

# Associate the NACL with each private subnet
resource "aws_network_acl_association" "private_subnet_association" {
  count = length(module.vpc.private_subnets)

  subnet_id       = element(module.vpc.private_subnets, count.index)
  network_acl_id  = aws_network_acl.nacl01.id
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "alb" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-alb-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecs"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-ecs-endpoint"
  }
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-cloudwatch-endpoint"
  }
}

resource "aws_vpc_endpoint" "api" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.execute-api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "${var.project}-${var.environment}-${var.reg}-ecr-dkr-endpoint"
  }
}



/* resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecs-agent"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "ecs-agent-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecs-telemetry"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg01.id]
  subnet_ids        = module.vpc.private_subnets
  tags = {
    Name = "ecs-telemetry-endpoint"
  }
} */