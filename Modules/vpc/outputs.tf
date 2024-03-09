output "qnt_vpc_id" {
  description = "VPC Id"
  value       = aws_vpc.qntVPC.id
}

output "qnt_public_subnets" {
  description = "Will be used by Web Server Module to set subnet_ids"
  value = [
    aws_subnet.qntPublicSubnet1,
    aws_subnet.qntPublicSubnet2
  ]
}

output "qnt_private_subnets" {
  description = "Will be used by RDS Module to set subnet_ids"
  value = [
    aws_subnet.qntPrivateSubnet1,
    aws_subnet.qntPrivateSubnet2
  ]
}