# fastapi-ecs-demo

## Prerequisites
1. You have the AWS CLI installed and are able to execute commands, e.g. `aws s3 ls`
2. Terraform installed
3. Docker installed to test, build and push images

> [!NOTE]
> The **fastapi-app** repository has to exist in Amazon Elastic Container Registry (ECR) in your AWS account

## Build and publish the Docker image

```bash
export AWS_ACCT_ID="<AWS account id>"

# confirm the repo exists in ECR
aws ecr describe-repositories --query "repositories[].[repositoryName]" --output text --no-cli-pager

# get ECR repository credentials & log docker into the repo
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com

# build the docker image
docker build -t fastapi-demo .

# test container (change port 8881 as required)
docker run --rm --interactive --name test-fastapi-demo --publish 8881:8081 fastapi-demo:latest

# tag image for ECR
docker tag fastapi-demo:latest ${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com/fastapi-demo:latest

# push image to ECR
docker push ${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com/fastapi-demo:latest
```

## Launch the application in Amazon Elastic Container Service (ECS)

```bash
cd terraform

terraform init -backend=false

# confirm that the configuration is valid
terraform validate

# add variables to terraform.tfstate file or as arguments for the following commands
# e.g: -var "docker_image_url_app=${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com/fastapi-demo:latest"
terraform plan
terraform apply -auto-approve
```

## Test application

The Terraform output will display the DNS name where the app can be accessed. 
You should be able to see the API documentation if you append `/docs` to the end of the URL, e.g. http://demo-alb-......us-west-2.elb.amazonaws.com/docs

If changes are made to the FastApi app and a new image pushed, the cluster has to be redeployed:
```bash
aws ecs update-service --cluster demo-cluster --service demo-service --force-new-deployment
```

## Destroy previously-created infrastructure in AWS

```bash
cd terraform

# see what will be destroyed
terraform plan -destroy

# destroy resources
terraform destroy -auto-approve
```
