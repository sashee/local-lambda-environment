FUNCTION="aws_lambda_function.$1"

shift

ENV_VARS=$(terraform state show $FUNCTION | sed -n '/environment {$/,/}$/p' | sed '1,2d;$d' | awk '{print gensub(/^[^\"]*\"([^\"]*)\"[^\"]*\"(.*)\"[^\"]*$/, "export \\1=\"\\2\"\n", "g" $0)}')
ROLE=$(aws sts assume-role --role-arn "$(terraform state show $FUNCTION | awk '/role/ {print gensub(/^\"(.*)\"$/, "\\1", "g", $3)}')" --role-session-name test | jq -r '.Credentials | {AWS_ACCESS_KEY_ID: .AccessKeyId, AWS_SECRET_ACCESS_KEY: .SecretAccessKey, AWS_SESSION_TOKEN: .SessionToken} | to_entries[] | "export \(.key)=\"\(.value)\"\n"')
REGION=$(terraform state show $FUNCTION | awk '/arn/ {print gensub(/^\"(.*)\"$/, "\\1", "g", $3)}' | head -1 | awk -F: '{print "export AWS_REGION="$4}')

PARAMS="$ENV_VARS $ROLE $REGION"

COMMAND="($(echo $PARAMS) ; bash -c \""$@"\")"
eval "$COMMAND"

