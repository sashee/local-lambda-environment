output "policy" {
  value = data.aws_iam_policy_document.devmode_assume_role_policy.json
}
