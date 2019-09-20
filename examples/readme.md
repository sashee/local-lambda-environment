## Emulate the lambda environment locally

This is a demonstartion project to show how to emulate the real lambda environment variables locally. This takes care of:

* fetching the environment variables the lambda functions gets
* using the role that is assigned to the function

In effect, you don't need to deploy every time you want to see a change. Your local environment will use the same resources and the same role the real lambda will.

### Infrastructure

This will set up a Lambda function with an API Gateway to expose a HTTP endpoint. It also creates an S3 bucket and an Object inside and the function reads the
content. The bucket is private, and only the role has permissions.

### Deploy the lambda function

* ```(cd src && npm ci)```
* ```terraform apply```
* navigate to the URL

Observe that the Bucket's content is printed.

### Run it locally

* ```terraform apply -var 'dev_mode=true'```
* ```./run.sh lambda "node src/index.js"```
* navigate to [http://localhost:3000](http://localhost:3000)

Observe that the Bucket's content is printed.

This means that the locally run application has the same environment variables set (both the role and the bucket/object location).
