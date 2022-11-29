locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

module "eks" {
  source  = "./modules/eks"
  cluster_name                    = local.name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = var.create_cluster_security_group
  create_node_security_group    = var.create_node_security_group

    fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]

      # Using specific subnets instead of the subnets supplied for the cluster itself
      subnet_ids = [module.vpc.private_subnets[1]]

    }

    kube_system = {
      name = "kube-system"
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

}

module "vpc" {
  source  = "./modules/vpc"

  name = local.name
  cidr = var.cidr

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.default_vpc_enable_dns_hostnames

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

}
