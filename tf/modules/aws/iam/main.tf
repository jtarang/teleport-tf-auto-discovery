# IAM Policy for Teleport AWS Discovery (EC2, RDS, EKS only)
resource "aws_iam_policy" "teleport_discovery_policy" {
  name        = "${var.iam_role_and_policy_prefix}-teleport-discovery-policy"
  description = "Policy to allow Teleport to discover EC2, RDS, and EKS resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # EC2 Discovery
      {
        Sid    = "EC2Discovery"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:ModifyInstanceMetadataOptions"
        ]
        Resource = "*"
      },

      # RDS Discovery and IAM Auth
      {
        Sid    = "RDSDiscovery"
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:ModifyDBInstance",
          "rds:ModifyDBCluster",
          "rds-db:connect"
        ]
        Resource = "*"
      },
      # Elasticache Discovery
      {
        Sid    = "ElastiCacheSDiscovery"
        Effect = "Allow"
        Action = [
          "elasticache:DescribeReplicationGroups",
          "elasticache:DescribeUsers",
          "elasticache:Connect",
          "elasticache:DescribeServerlessCaches",
        ]
        Resource = "*"
      },

      # EKS Discovery
      {
        Sid    = "EKSDiscovery"
        Effect = "Allow"
        Action = [
          "eks:ListClusters",
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },

      {
        Sid    = "SecretsAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for Teleport Discovery
resource "aws_iam_role" "teleport_discovery_role" {
  name = "${var.iam_role_and_policy_prefix}-teleport-discovery-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "rds.amazonaws.com",
            "eks.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the discovery policy to the role
resource "aws_iam_role_policy_attachment" "teleport_discovery_attachment" {
  role       = aws_iam_role.teleport_discovery_role.name
  policy_arn = aws_iam_policy.teleport_discovery_policy.arn
}

# Instance profile for EC2-based discovery agents
resource "aws_iam_instance_profile" "teleport_discovery_instance_profile" {
  name = "${var.iam_role_and_policy_prefix}-teleport-discovery-instance-profile"
  role = aws_iam_role.teleport_discovery_role.name
}
