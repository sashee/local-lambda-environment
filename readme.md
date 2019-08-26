## Devmode enabled assume role policy

### Why

If you develop a Lambda function, your assume role policy looks like this:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
```

The problem is that you can not assume it with a CLI so that you have no way of running your Lambda function locally with the correct role.

The solution is to allow the current account to assume that role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "<account id>"
      },
      "Effect": "Allow"
    }
  ]
}
```

But that is a bad idea to leave it on for production, so the addition of that statement should be switchable.

To see how to emulate a real lambda locally, check out the [example](example).

### How to use

```terraform
module "devmode_assume_role_policy" {
  source = "github.com/sashee/local-lambda-environment"

  dev_mode = var.dev_mode
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_exec" {
  assume_role_policy = module.devmode_assume_role_policy.policy
}
```

Whenever ```devmode``` is true the extra statement is appended. When it's false, the assume role policy is left intact.
