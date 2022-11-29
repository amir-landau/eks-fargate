cluster_endpoint_private_access = true

create_cloudwatch_log_group = false

create_cluster_security_group = false

create_node_security_group = false

enable_nat_gateway = true

single_nat_gateway = true

default_vpc_enable_dns_hostnames = true

cluster_version = "1.24"

region = "us-west-2"

vpc_version = "3.18.1"

cidr = "10.0.0.0/16"

azs = [
  "us-west-2a",
  "us-west-2b"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.4.0/24",
  "10.0.5.0/24"
]
