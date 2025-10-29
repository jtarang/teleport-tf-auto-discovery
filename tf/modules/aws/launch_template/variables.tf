variable "image_id" {
  description = "The ID of the AMI to launch EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}

variable "nsg_ids" {
  description = "The ID of the security group to associate with EC2 instances"
  type        = set(string)
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to associate with the EC2 instances"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to the resource"
  type        = map(string)
}

variable "launch_template_prefix" {
  description = "Name prefix for the launch template"
  type        = string
}

variable "ec2_ami_ssm_parameter" {
  description = "Path to latest ami SSM parameter"
  type        = string
}

variable "ec2_bootstrap_script_path" {
  description = "EC2 bootstrap or cloud-init script path"
  type        = string
}

variable "iam_instance_role_name" {
  description = "The Name of the IAM role to be associated with EC2 instances profile."
  type        = string
}

variable "environment_tag" {
  description = "Environment Tag Value: dev, stg, prd"
  default = "dev" 
}

variable "teleport_edition" {
  description = "Teleport Edition to install i.e(cloud, enterprise, oss)"
  type        = string
}

variable "teleport_address" {
  description = "Teleport Domain/Address; this is grabbed from the local env vars from tctl"
  type        = string
}

variable "teleport_node_join_token" {
  description = "Teleport Node Join Token"
  type        = string
  default =   ""
}

variable "teleport_discovery_tag_value" {
  description = "Value for teleport-discovery tag value"
  default = ""
}

variable "teleport_display_name_strip_string" {
  description = "Strip any value to node and db names for Teleport Display Names"
  default = " "
}

variable "teleport_windows_server_display_name" {
  description = "Teleport Display name for the Windows Server"
  default = ""
}

variable "teleport_windows_server_private_ip" {
  description = "Private IP for the Windows Server"
  default = ""
}