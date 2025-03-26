locals {
  name   = "${basename(path.cwd)}"
  region = "us-east-1"

  vpc_cidr = "110.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  nat_type = "instance" #"instance" or "gateway"

  tags = {
    created_by    = split("/", data.aws_caller_identity.current.arn)[1]
    creation_date = data.external.date.result["stdout"]
    # creation_date = formatdate("DD-MM-YY", timestamp())
    project_name = "poc"
  }

  user_data = <<-EOT
    #!/bin/bash
    sudo sed -i -e '/secure_path/ s[=.*[&:/usr/local/bin[' /etc/sudoers
    echo "=============SELINUX UPDATE======================"
    sudo amazon-linux-extras enable selinux-ng
    sudo yum clean metadata
    sudo yum install selinux-policy-targeted -y
    echo "=============AWS-CLI INSTALLATION===================="
    sudo yum remove awscli -y
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo unzip awscliv2.zip
    sudo ./aws/install
    sudo rm -fr awscliv2.zip aws
    echo "=============GIT INSTALLATION===================="
    sudo yum install -y git
    echo "=============K3S INSTALLATION===================="
    sudo curl -sfL https://get.k3s.io | bash -s - --disable=traefik,servicelb,local-storage
    sudo mkdir -p /root/.kube
    sudo ln -s /etc/rancher/k3s/k3s.yaml /root/.kube/config
    sudo echo "alias k=kubectl" >> /root/.bashrc
    sudo echo "alias ka='kubectl apply -f'" >> /root/.bashrc
    sudo echo "alias kd='kubectl delete -f'" >> /root/.bashrc
    sudo echo "alias managed='watch kubectl get managed'" >> /root/.bashrc
    echo "=============K9S INSTALLATION===================="
    export HOME=/root
    sudo curl -sS https://webinstall.dev/k9s | bash
    sudo cp /root/.local/bin/k9s /usr/local/bin/
    sudo rm -fr /root/Downloads
    echo "=============CROSSPLANE INSTALLATION===================="
    sudo curl -sL "https://raw.githubusercontent.com/crossplane/crossplane/main/install.sh" | bash
    sudo mv crossplane /usr/local/bin
    echo "=============HELM INSTALLATION===================="
    sudo curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "=============CROSSPLANE INSTALLATION===================="
    sudo helm repo add crossplane-stable https://charts.crossplane.io/stable
    sudo helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane
  EOT

}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = local.nat_type == "gateway" ? true : false
  single_nat_gateway = true

  tags = local.tags
}

module "nat_instance" {
  source  = "RaJiska/fck-nat/aws"
  version = "1.3.0"
  count   = local.nat_type == "instance" ? 1 : 0

  name                       = "${local.name}-nat-instance"
  vpc_id                     = module.vpc.vpc_id
  subnet_id                  = element(module.vpc.public_subnets, 0)
  instance_type              = "t4g.nano"
  use_spot_instances         = true
  ha_mode                    = false # Enables high-availability mode
  use_cloudwatch_agent       = false # Enables Cloudwatch agent and have metrics reported
  use_default_security_group = false
  update_route_tables        = true
  route_tables_ids = {
    private = module.vpc.private_route_table_ids[0]
  }
  tags = local.tags
}

################################################################################
# EC2 Module
################################################################################

module "ec2_spot_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name                 = "${local.name}-spot-instance"
  ami_ssm_parameter    = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  create_spot_instance = true

  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]

  # Spot request specific attributes
  spot_price                          = "0.4"
  spot_wait_for_fulfillment           = true
  spot_type                           = "persistent"
  spot_instance_interruption_behavior = "terminate"
  # End spot request specific attributes
  instance_type = "c5.xlarge"

  user_data_base64 = base64encode(local.user_data)

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    # AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    }
  ]

  tags = local.tags
}

# EC2 instances created by spot requests without launch template are not tagged by default. This resource tags the instance.
resource "aws_ec2_tag" "spot_instance_tags" {
  for_each    = merge(local.tags, { Name = "${local.name}-spot-cluster" })
  resource_id = module.ec2_spot_instance.spot_instance_id
  key         = each.key
  value       = each.value
}

################################################################################
# Security Group Module
################################################################################

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "${local.name}-spot-instance-sg"
  description = "Security group for K3s EC2 instance"
  vpc_id      = module.vpc.vpc_id

  #ingress_cidr_blocks = ["0.0.0.0/0"]
  #ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules = ["all-all"]

  tags = local.tags
}