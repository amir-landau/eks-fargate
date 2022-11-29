provider "aws" {
  region = var.region
}

terraform {
 backend "s3" {
   region = "us-west-2"
   bucket = "tf-eks-nginx-us-west-2"
   key    = "terraform.tfstate"
 }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}




