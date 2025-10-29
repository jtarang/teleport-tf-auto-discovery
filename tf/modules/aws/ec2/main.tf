data "aws_region" "current" {}

resource "aws_instance" "ec2_instance" {
  ## AMI and Instance Type defined in the `launch template`  
  #ami                    = var.image_id  
  #instance_type          = var.instance_type

  # Use the Launch Template
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  subnet_id       = var.public_subnet_ids[0]

  tags = merge( { for k, v in var.tags : k == "teleport.dev/creator" ? "instance_metadata_tagging_req" : k => v }, {
    "Name" = "${var.user_prefix}-ec2"
  })
  
  lifecycle {
    ignore_changes = [
      launch_template, # don’t recreate on new LT versions
      security_groups
    ]
  }
}