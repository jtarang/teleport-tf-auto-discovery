module "external_data" {
  source = "./modules/external_data"
}

module "teleport" {
  source = "./modules/teleport"
}

module "vpc" {
  source                  = "./modules/aws/vpc"
  tags                    = var.tags
  vpc_cidr_block          = var.vpc_cidr_block
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zones      = var.availability_zones
  user_prefix             = var.user_prefix
}

module "nsg" {
  source         = "./modules/aws/nsg"
  vpc_id         = module.vpc.vpc_id
  user_prefix    = var.user_prefix
  vpc_cidr_block = var.vpc_cidr_block
  my_external_ip = module.external_data.my_external_ip
  tags           = var.tags
}

module "iam" {
  source = "./modules/aws/iam"
  iam_role_and_policy_prefix = var.iam_role_and_policy_prefix
}

module "dev_linux_launch_template" {
  source                    = "./modules/aws/launch_template"
  image_id                  = var.linux_ec2_image_id
  launch_template_prefix    = "${var.user_prefix}-linux-launch-template"
  ec2_ami_ssm_parameter     = var.linux_ec2_ami_ssm_parameter
  ec2_bootstrap_script_path = var.linux_ec2_bootstrap_script_path
  instance_type             = var.linux_ec2_instance_type
  nsg_ids                   = [module.nsg.nsg_id]
  ssh_key_name              = "${var.ssh_key_name}-${var.aws_region}"
  tags                      = var.tags
  iam_instance_role_name = module.iam.discovery_role.name
  teleport_edition = var.teleport_edition
  teleport_address = var.teleport_address
  teleport_node_join_token = module.teleport.teleport_join_token
  teleport_windows_server_display_name = "${var.user_prefix}-windows-node"
  teleport_discovery_tag_value = var.teleport_discovery_tag_value
  teleport_windows_server_private_ip = module.windows_node_ec2.private_ip
}

module "dev_windows_launch_template" {
  source                    = "./modules/aws/launch_template"
  image_id                         = var.windows_ec2_image_id
  instance_type                    = var.windows_ec2_instance_type
  launch_template_prefix    = "${var.user_prefix}-windows-launch-template"
  ec2_ami_ssm_parameter     = var.windows_ec2_ami_ssm_parameter
  ec2_bootstrap_script_path = var.windows_ec2_bootstrap_script_path
  nsg_ids                          = [module.nsg.nsg_id]
  ssh_key_name                     = "${var.ssh_key_name}-${var.aws_region}"
  tags                             = var.tags
  iam_instance_role_name           = module.iam.discovery_role.name
  teleport_edition = var.teleport_edition
  teleport_address = var.teleport_address
}

module "linux_node_ec2" {
  source = "./modules/aws/ec2"
  tags                             = var.tags
  launch_template_id               = module.dev_linux_launch_template.launch_template_id
  public_subnet_ids                = [module.vpc.public_subnet_ids[0]]
  user_prefix                      = "${var.user_prefix}-linux-node"
  }

module "windows_node_ec2" {
  source = "./modules/aws/ec2"
  tags                             = var.tags
  launch_template_id               = module.dev_windows_launch_template.launch_template_id
  public_subnet_ids                = [module.vpc.public_subnet_ids[0]]
  user_prefix                      = "${var.user_prefix}-windows-node"
  }

module "rds" {
  source                 = "./modules/aws/rds"
  rds_db_instance_identifier = "${var.rds_db_instance_identifier}"
  rds_db_username            = var.rds_db_username
  rds_db_teleport_admin_user = var.rds_db_teleport_admin_user
  # DB Password is now managed in secrets manager
  rds_db_name                      = "${var.rds_db_name}"
  rds_db_port                      = var.rds_db_port
  rds_db_instance_class            = var.rds_db_instance_class
  rds_db_allocated_storage         = var.rds_db_allocated_storage
  rds_db_storage_type              = var.rds_db_storage_type
  rds_db_engine                    = var.rds_db_engine
  rds_db_engine_version            = var.rds_db_engine_version
  rds_db_publicly_accessible       = var.rds_db_publicly_accessible
  rds_db_multi_az                  = var.rds_db_multi_az
  rds_db_backup_retention_period   = var.rds_db_backup_retention_period
  rds_db_skip_final_snapshot       = var.rds_db_skip_final_snapshot
  rds_db_storage_encrypted         = var.rds_db_storage_encrypted
  rds_db_parameter_group_name      = var.rds_db_parameter_group_name
  rds_db_security_group_ids        = [module.nsg.nsg_id]
  rds_db_tags                      = var.tags
  rds_db_subnet_group_name         = "${var.user_prefix}-rds-db-group"
  rds_db_subnet_ids                = flatten([module.vpc.public_subnet_ids, module.vpc.private_subnet_ids])
}


module "eks" {
  source                 = "./modules/aws/eks"
  eks_cluster_name       = "${var.user_prefix}-eks"
  eks_cluster_version    = var.eks_cluster_version
  eks_subnet_ids         = flatten([module.vpc.public_subnet_ids, module.vpc.private_subnet_ids]) # Flattening the list of subnet IDs
  eks_security_group_ids = [module.nsg.nsg_id]
  eks_node_instance_type = var.eks_node_instance_type
  eks_node_count         = var.eks_node_desired_capacity
  eks_node_min_size      = var.eks_node_min_capacity
  eks_node_max_size      = var.eks_node_max_capacity
  tags                   = var.tags
}
