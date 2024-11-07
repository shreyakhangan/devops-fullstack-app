provider "aws" {
  region = "us-east-1"
}

# Define variables for the existing VPC and subnets
variable "vpc_id" {
  description = "vpc-081f30b671b5a8b76"
  type        = string
}

variable "subnet_ids" {
  description = "subnet-036c9cb6d0bee2982"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "techverito-eks-cluster"
}

# Create the IAM role with administrative access
resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AdministratorAccess policy to the role
resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachment" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create the EC2 instance for EKS admin management
resource "aws_instance" "eks_admin_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t3.medium"
  subnet_id     = element(var.subnet_ids, 0)
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.eks_admin_profile.name

  tags = {
    Name = "EKS-Admin-Instance"
  }
}

# Create IAM instance profile for the EC2 instance
resource "aws_iam_instance_profile" "eks_admin_profile" {
  name = "eks-admin-profile"
  role = aws_iam_role.eks_admin_role.name
}

# Create the EKS cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.22"  # Specify the desired EKS version
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_size         = 3
      min_size         = 1

      instance_type = "t3.medium"
      key_name      = "your-ec2-keypair-name"  # Add your SSH key pair here
    }
  }
}

# Output the EKS cluster and EC2 admin instance details
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_admin_instance_id" {
  value = aws_instance.eks_admin_instance.id
}
