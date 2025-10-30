resource "aws_security_group" "nsg" {
  name        = "${var.user_prefix}-sg"
  description = "${var.user_prefix}: Network Security Group"
  vpc_id      = var.vpc_id
  
  
  tags = merge(var.tags, {
    "Name" = "${var.user_prefix}-nsg"
  })

  # Outbound rule: Allow all outbound traffic (default rule)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to anywhere
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.my_external_ip}/32"] # Restrict access to the specified IP only
  }

  #  Allow CoreDNS communication
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    self        = true
  }

  #  Allow Postgres
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true
  }

  #  Allow RDP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    self        = true
  }

}