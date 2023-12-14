# fastapi-ecs-demo

## Build and publish the Docker image

> [!NOTE]
> The **fastapi-demo** repository has to exist in Amazon Elastic Container Registry (ECR) in your AWS account

```bash
export AWS_ACCT_ID="<your account id here>"

# confirm the repo exists in ECR
aws ecr describe-repositories --query "repositories[].[repositoryName]" --output text --no-cli-pager

# build and push the docker image
cd app
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com
docker build -t fastapi-demo .
docker tag fastapi-demo:latest ${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com/fastapi-demo:latest
docker push ${AWS_ACCT_ID}.dkr.ecr.us-west-2.amazonaws.com/fastapi-demo:latest
```

## Launch the application in Amazon Elastic Container Service (ECS)

```bash
cd terraform
terraform validate
terraform plan
terraform apply -auto-approve
```

## Destroy previously-created infrastructure in AWS

```bash
cd terraform
terraform destroy -auto-approve
```