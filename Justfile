default:
  @just --choose

create-terraform-bucket:
  aws s3api create-bucket --bucket cardlink-terraform

delete-terraform-bucket:
  aws s3 rm s3://cardlink-terraform --recursive

create-terraform-dynamodb:
  aws dynamodb create-table \
    --table-name cardlink-terraform \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

delete-terraform-dynamodb:
  aws dynamodb delete-table --table-name cardlink-terraform

setup-terraform: create-terraform-bucket create-terraform-dynamodb
destroy-terraform: delete-terraform-bucket delete-terraform-dynamodb
