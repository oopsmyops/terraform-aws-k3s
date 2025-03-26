output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.vpc.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.vpc.default_route_table_id
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = module.vpc.vpc_instance_tenancy
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = module.vpc.vpc_enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = module.vpc.vpc_enable_dns_hostnames
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = module.vpc.vpc_main_route_table_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_ids
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc.igw_arn
}

output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = module.vpc.vpc_flow_log_id
}

output "vpc_flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = module.vpc.vpc_flow_log_destination_arn
}

output "vpc_flow_log_destination_type" {
  description = "The type of the destination for VPC Flow Logs"
  value       = module.vpc.vpc_flow_log_destination_type
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = module.vpc.vpc_flow_log_cloudwatch_iam_role_arn
}

# NAT Instance

output "nat_ami_id" {
  description = "AMI to use for the NAT instance. Uses fck-nat latest arm64 AMI in the region if none provided"
  value       = local.nat_type == "instance" ? module.nat_instance[0].ami_id : null
}

output "nat_encryption" {
  description = "Whether or not nat instance EBS volumes are encrypted"
  value       = local.nat_type == "instance" ? module.nat_instance[0].encryption : null
}

output "nat_eni_arn" {
  description = "The ARN of the static ENI used by the nat instance"
  value       = local.nat_type == "instance" ? module.nat_instance[0].eni_arn : null
}

output "nat_eni_id" {
  description = "The ID of the static ENI used by the nat instance"
  value       = local.nat_type == "instance" ? module.nat_instance[0].eni_id : null
}

output "nat_ha_mode" {
  description = "Whether or not high-availability mode is enabled via autoscaling group"
  value       = local.nat_type == "instance" ? module.nat_instance[0].ha_mode : null
}

output "nat_instance_arn" {
  description = "The ARN of the nat instance if running in non-HA mode"
  value       = local.nat_type == "instance" ? module.nat_instance[0].instance_arn : null
}

output "nat_instance_profile_arn" {
  description = "The ARN of the instance profile used by the nat instance"
  value       = local.nat_type == "instance" ? module.nat_instance[0].instance_profile_arn : null
}

output "nat_instance_public_ip" {
  description = "The public IP address of the nat instance if running in non-HA mode"
  value       = local.nat_type == "instance" ? module.nat_instance[0].instance_public_ip : null
}

output "nat_instance_type" {
  description = "Instance type used for the nat instance"
  value       = local.nat_type == "instance" ? module.nat_instance[0].instance_type : null
}

output "nat_kms_key_id" {
  description = "KMS key ID to use for encrypting nat instance EBS volumes"
  value       = local.nat_type == "instance" ? module.nat_instance[0].kms_key_id : null
}

output "nat_launch_template_id" {
  description = "The ID of the launch template used to spawn nat instances"
  value       = local.nat_type == "instance" ? module.nat_instance[0].launch_template_id : null
}

output "nat_name" {
  description = "Name used for resources created within the module"
  value       = local.nat_type == "instance" ? module.nat_instance[0].name : null
}

output "nat_role_arn" {
  description = "The ARN of the role used by the nat instance profile"
  value       = local.nat_type == "instance" ? module.nat_instance[0].role_arn : null
}

output "nat_security_group_ids" {
  description = "List of security group IDs used by nat ENIs"
  value       = local.nat_type == "instance" ? module.nat_instance[0].security_group_ids : null
}

# EC2 Spot Instance
output "ec2_spot_instance_id" {
  description = "The ID of the instance"
  value       = module.ec2_spot_instance.id
}

output "ec2_spot_instance_arn" {
  description = "The ARN of the instance"
  value       = module.ec2_spot_instance.arn
}

output "ec2_spot_instance_instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = module.ec2_spot_instance.instance_state
}

output "ec2_spot_instance_primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = module.ec2_spot_instance.primary_network_interface_id
}

output "ec2_spot_instance_private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_spot_instance.private_dns
}

output "ec2_spot_instance_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_spot_instance.public_dns
}

output "ec2_spot_instance_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2_spot_instance.public_ip
}

output "spot_bid_status" {
  description = "The current bid status of the Spot Instance Request"
  value       = module.ec2_spot_instance.spot_bid_status
}

output "spot_request_state" {
  description = "The current request state of the Spot Instance Request"
  value       = module.ec2_spot_instance.spot_request_state
}

output "spot_instance_id" {
  description = "The Instance ID (if any) that is currently fulfilling the Spot Instance request"
  value       = module.ec2_spot_instance.spot_instance_id
}

output "spot_instance_availability_zone" {
  description = "The availability zone of the created spot instance"
  value       = module.ec2_spot_instance.availability_zone
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = module.security_group.security_group_arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.security_group.security_group_name
}