variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_profile_name" {
  description = "AWS Profile to use for authentication"
  type = string
  default = ""
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones to create subnets in"
  type        = list(string)
}

variable "ssh_key_name" {
  description = "Key name for the SSH key"
}

variable "map_public_ip_on_launch" {
  description = "Whether instances in the subnet should automatically receive a public IP on launch"
  type        = bool
}

variable "user_prefix" {
  description = "User Prefix is used to make the resource owner identifiable"
}

variable "tags" {
  description = "A map of tags to apply to the resource"
  type        = map(string)
}

variable "linux_ec2_instance_type" {
  description = "value"
  type = string
}

variable "linux_ec2_image_id" {
  description = "The AMI (Amazon Machine Image) ID for the EC2 instance"
  type        = string
}

variable "linux_ec2_bootstrap_script_path" {
  description = "EC2 bootstrap or cloud-init script path"
  type        = string
}

variable "linux_ec2_ami_ssm_parameter" {
  description = "Path to latest ami SSM parameter"
  type        = string
}

variable "windows_ec2_instance_type" {
  description = "value"
  type = string
}

variable "windows_ec2_image_id" {
  description = "The AMI (Amazon Machine Image) ID for the EC2 instance"
  type        = string
}

variable "windows_ec2_bootstrap_script_path" {
  description = "EC2 bootstrap or cloud-init script path"
  type        = string
}

variable "windows_ec2_ami_ssm_parameter" {
  description = "Path to latest ami SSM parameter"
  type        = string
}

variable "teleport_edition" {
  description = "Teleport Edition to install i.e(cloud, enterprise, oss)"
  type        = string
}

variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "eks_node_instance_type" {
  description = "The EC2 instance type for the EKS node group"
  type        = string
}

variable "eks_node_desired_capacity" {
  description = "The desired number of nodes in the EKS node group"
  type        = number
}

variable "eks_node_min_capacity" {
  description = "The minimum size of the EKS node group"
  type        = number
}

variable "eks_node_max_capacity" {
  description = "The maximum size of the EKS node group"
  type        = number
}

variable "rds_db_instance_identifier" {
  description = "The name of the DB instance."
  type        = string
}

variable "rds_db_allocated_storage" {
  description = "The allocated storage for the DB instance."
  type        = number
}

variable "rds_db_storage_type" {
  description = "The storage type for the DB instance."
  type        = string
}

variable "rds_db_engine" {
  description = "The database engine for the instance."
  type        = string
}

variable "rds_db_engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "rds_db_instance_class" {
  description = "The instance class of the DB instance."
  type        = string
}

# DB Password is managed now
variable "rds_db_username" {
  description = "The master username for the DB instance."
  type        = string
}

variable "rds_db_name" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
}

variable "rds_db_port" {
  description = "The port on which the DB instance will listen."
  type        = number
}

variable "rds_db_publicly_accessible" {
  description = "Indicates whether the DB instance is publicly accessible."
  type        = bool
}

variable "rds_db_backup_retention_period" {
  description = "The backup retention period for the DB instance."
  type        = number
}

variable "rds_db_multi_az" {
  description = "Specifies if the DB instance is a Multi-AZ deployment."
  type        = bool
}

variable "rds_db_skip_final_snapshot" {
  description = "Determines whether a final snapshot is created before the DB instance is deleted."
  type        = bool
}

variable "rds_db_storage_encrypted" {
  description = "Specifies if the DB instance storage is encrypted."
  type        = bool
}

variable "rds_db_parameter_group_name" {
  description = "The DB parameter group name."
  type        = string
}

variable "rds_db_teleport_admin_user" {
  description = "Teleport Database Admin user to auto create and manage users"
  type = string
}

variable "teleport_address" {
  description = "Teleport Domain/Address; this is grabbed from the local env vars from tctl"
  type = string
}

variable "teleport_identity_file_base64" {
  description = "Teleport Identity File in base64"
  type = string
}

variable "iam_role_and_policy_prefix" {
  description = "Prefix for IAM role and policy names"
  type        = string
}

variable "teleport_discovery_tag_value" {
  description = "Value for teleport-discovery tag value"
  type = string
}

variable "teleport_display_name_strip_string" {
  description = "Strip any value to node and db names for Teleport Display Names"
  default = " "
}