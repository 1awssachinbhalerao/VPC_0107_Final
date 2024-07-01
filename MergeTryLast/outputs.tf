output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "The list of private subnets"
  value       = module.vpc.private_subnets
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sg01.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.sg01.tags.Name
}


output "network_acl_id" {
  description = "The ID of the network ACL"
  value       = aws_network_acl.nacl01.id
}

output "s3_vpc_endpoint_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "alb_vpc_endpoint_id" {
  description = "The ID of the ALB VPC endpoint"
  value       = aws_vpc_endpoint.alb.id
}

output "ecs_vpc_endpoint_id" {
  description = "The ID of the ECS VPC endpoint"
  value       = aws_vpc_endpoint.ecs.id
}

output "cloudwatch_vpc_endpoint_id" {
  description = "The ID of the CloudWatch VPC endpoint"
  value       = aws_vpc_endpoint.cloudwatch.id
}

output "api_vpc_endpoint_id" {
  description = "The ID of the API VPC endpoint"
  value       = aws_vpc_endpoint.api.id
}

output "ecr_api_vpc_endpoint_id" {
  description = "The ID of the ECR API VPC endpoint"
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_vpc_endpoint_id" {
  description = "The ID of the ECR Docker VPC endpoint"
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "vpc_endpoint_ids" {
  description = "A map of all VPC endpoint IDs"
  value = {
    s3         = aws_vpc_endpoint.s3.id
    alb        = aws_vpc_endpoint.alb.id
    ecs        = aws_vpc_endpoint.ecs.id
    cloudwatch = aws_vpc_endpoint.cloudwatch.id
    api        = aws_vpc_endpoint.api.id
    ecr_api    = aws_vpc_endpoint.ecr_api.id
    ecr_dkr    = aws_vpc_endpoint.ecr_dkr.id
  }
}