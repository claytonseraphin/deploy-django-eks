locals {
  cluster_name = "${var.prefix}-cluster"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = "1.33"

  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnets
  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"] # you can also pass your machine ip address to restrict access to your computer only.
  endpoint_private_access      = true

  addons = {
    vpc-cni = {
      before_compute           = true
      most_recent              = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
    kube-proxy = {
      before_compute = true
      most_recent    = true
    }
    coredns = {
      most_recent = true
    }
  }

  iam_role_additional_policies = {
    AllowECRApp   = aws_iam_policy.allow_ecr_app.arn
    AllowECRProxy = aws_iam_policy.allow_ecr_proxy.arn
  }

  eks_managed_node_groups = {
    general = {
      name           = "k8s-ng-1"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      labels = {
        Environment = "Dev"
      }

    }
  }
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name_prefix      = "${var.prefix}-vpc-cni-irsa"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}
