output "discovery_policy_arn" {
  description = "Teleport Discovery policy"
  value       = aws_iam_policy.teleport_discovery_policy
}

output "discovery_role" {
  description = "The IAM role for EC2, ECK and RDS discovery"
  value       = aws_iam_role.teleport_discovery_role
}

output "discovery_role_policy_attachment_id" {
  description = "The ID of the role-policy attachment"
  value       = aws_iam_role_policy_attachment.teleport_discovery_attachment.id
}