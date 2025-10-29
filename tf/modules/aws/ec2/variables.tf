variable "tags" {
  description = "A map of tags to apply to the resource"
  type        = map(string)
}

variable "launch_template_id" {
  description = "The ID of the Launch Template for EC2 instances in the Auto Scaling Group"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnet where EC2 instances will be launched"
  type        = list(string)
}

variable "user_prefix" {
  description = "User Prefix is used to make the resource owner identifiable"
}
