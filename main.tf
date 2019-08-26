data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "dev_statement" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }
  }
}

data "aws_iam_policy_document" "devmode_assume_role_policy" {
  override_json = var.dev_mode ? data.aws_iam_policy_document.dev_statement.json : null
  source_json   = var.policy
}
