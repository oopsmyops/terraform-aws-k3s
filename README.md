# Terraform AWS K3s

This repository provides Terraform configurations to deploy and manage a K3s cluster on AWS. It uses Terraform modules to provision infrastructure components such as EC2 instances, VPCs, security groups, and NAT gateways.

## Folder Structure

- **`main.tf`**: Defines the primary resources for the infrastructure.
- **`variables.tf`**: Contains input variables for the configuration.
- **`outputs.tf`**: Specifies the outputs of the configuration.
- **`providers.tf`**: Configures the required providers.
- **`versions.tf`**: Declares the required Terraform and provider versions.
- **`data.tf`**: Includes data sources used in the configuration.

## Usage
1. **Pre-requisites**:
    - Install [Terraform](https://www.terraform.io/downloads.html).
    - Configure AWS CLI with appropriate credentials.
    - Ensure you have the necessary IAM permissions to create resources.

2. **Initialize Terraform**:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

## Modules
This repository uses the following modules:
- **VPC Module**: Provisions the Virtual Private Cloud (VPC) and subnets.
- **EC2 Module**: Manages the EC2 instances for the K3s cluster.
- **Security Group Module**: Configures security groups for network access control.
- **NAT Instance Module**: Sets up NAT instance for internet access.

## Outputs  

### VPC Outputs
- **`vpc_id`**: The ID of the VPC.
- **`vpc_arn`**: The ARN of the VPC.
- **`vpc_cidr_block`**: The CIDR block of the VPC.
- **`default_security_group_id`**: The ID of the security group created by default on VPC creation.
- **`default_network_acl_id`**: The ID of the default network ACL.
- **`default_route_table_id`**: The ID of the default route table.
- **`vpc_instance_tenancy`**: Tenancy of instances spun up within the VPC.
- **`vpc_enable_dns_support`**: Whether or not the VPC has DNS support.
- **`vpc_enable_dns_hostnames`**: Whether or not the VPC has DNS hostname support.
- **`vpc_main_route_table_id`**: The ID of the main route table associated with this VPC.

### Subnet Outputs
- **`private_subnets`**: List of IDs of private subnets.
- **`private_subnet_arns`**: List of ARNs of private subnets.
- **`private_subnets_cidr_blocks`**: List of CIDR blocks of private subnets.
- **`public_subnets`**: List of IDs of public subnets.
- **`public_subnets_cidr_blocks`**: List of CIDR blocks of public subnets.

### Route Table and NAT Outputs
- **`public_route_table_ids`**: List of IDs of public route tables.
- **`private_route_table_ids`**: List of IDs of private route tables.
- **`nat_ids`**: List of allocation IDs of Elastic IPs created for AWS NAT Gateway.
- **`nat_public_ips`**: List of public Elastic IPs created for AWS NAT Gateway.
- **`natgw_ids`**: List of NAT Gateway IDs.

### Internet Gateway Outputs
- **`igw_id`**: The ID of the Internet Gateway.
- **`igw_arn`**: The ARN of the Internet Gateway.

### VPC Flow Log Outputs
- **`vpc_flow_log_id`**: The ID of the Flow Log resource.
- **`vpc_flow_log_destination_arn`**: The ARN of the destination for VPC Flow Logs.
- **`vpc_flow_log_destination_type`**: The type of the destination for VPC Flow Logs.
- **`vpc_flow_log_cloudwatch_iam_role_arn`**: The ARN of the IAM role used when pushing logs to CloudWatch log group.

### NAT Instance Outputs
- **`nat_ami_id`**: AMI to use for the NAT instance.
- **`nat_encryption`**: Whether or not NAT instance EBS volumes are encrypted.
- **`nat_eni_arn`**: The ARN of the static ENI used by the NAT instance.
- **`nat_eni_id`**: The ID of the static ENI used by the NAT instance.
- **`nat_ha_mode`**: Whether or not high-availability mode is enabled via autoscaling group.
- **`nat_instance_arn`**: The ARN of the NAT instance if running in non-HA mode.
- **`nat_instance_profile_arn`**: The ARN of the instance profile used by the NAT instance.
- **`nat_instance_public_ip`**: The public IP address of the NAT instance if running in non-HA mode.
- **`nat_instance_type`**: Instance type used for the NAT instance.
- **`nat_kms_key_id`**: KMS key ID to use for encrypting NAT instance EBS volumes.
- **`nat_launch_template_id`**: The ID of the launch template used to spawn NAT instances.
- **`nat_name`**: Name used for resources created within the module.
- **`nat_role_arn`**: The ARN of the role used by the NAT instance profile.
- **`nat_security_group_ids`**: List of security group IDs used by NAT ENIs.

### EC2 Spot Instance Outputs
- **`ec2_spot_instance_id`**: The ID of the instance.
- **`ec2_spot_instance_arn`**: The ARN of the instance.
- **`ec2_spot_instance_instance_state`**: The state of the instance.
- **`ec2_spot_instance_primary_network_interface_id`**: The ID of the instance's primary network interface.
- **`ec2_spot_instance_private_dns`**: The private DNS name assigned to the instance.
- **`ec2_spot_instance_public_dns`**: The public DNS name assigned to the instance.
- **`ec2_spot_instance_public_ip`**: The public IP address assigned to the instance.
- **`spot_bid_status`**: The current bid status of the Spot Instance Request.
- **`spot_request_state`**: The current request state of the Spot Instance Request.
- **`spot_instance_id`**: The Instance ID (if any) that is currently fulfilling the Spot Instance request.
- **`spot_instance_availability_zone`**: The availability zone of the created Spot Instance.

### Security Group Outputs
- **`security_group_arn`**: The ARN of the security group.
- **`security_group_id`**: The ID of the security group.
- **`security_group_name`**: The name of the security group.
## Notes

- **Secure State File**: Ensure that the Terraform state file (`terraform.tfstate`) is stored securely, as it contains sensitive information.
- **Use Remote Backend**: For production environments, use a remote backend (e.g., AWS S3 with DynamoDB for state locking) to manage the Terraform state securely and enable collaboration.
- **IAM Permissions**: Verify that the IAM user or role used has the necessary permissions to access the remote backend and manage resources.
- **State Encryption**: Enable encryption for the state file when using a remote backend to protect sensitive data.
- **Version Control**: Avoid committing the state file or sensitive variables to version control systems.
- **Environment Isolation**: Use separate state files or workspaces for different environments (e.g., dev, staging, production) to prevent accidental resource modifications.
- **Backup State**: Regularly back up the state file to ensure recoverability in case of corruption or accidental deletion.
- **State Locking**: Enable state locking to prevent concurrent modifications that could lead to inconsistencies.
- **Sensitive Variables**: Use environment variables or a secrets management tool to handle sensitive input variables securely.
- **Plan Before Apply**: Always run `terraform plan` to review changes before applying them to avoid unintended modifications.
- **Resource Cleanup**: Use `terraform destroy` cautiously to clean up resources when they are no longer needed.
- **Monitor Costs**: Regularly monitor AWS costs to ensure that resources provisioned by Terraform are within budget.
- **Documentation**: Maintain up-to-date documentation for the Terraform configurations and workflows to facilitate team collaboration and onboarding.

