default:
  @just --choose

TallyToolTerraform := "tally-tool-terraform"

create-terraform-bucket:
  aws s3api create-bucket --bucket {{TallyToolTerraform}} \
    --create-bucket-configuration LocationConstraint=${AWS_DEFAULT_REGION}

delete-terraform-bucket:
  aws s3 rm s3://{{TallyToolTerraform}} --recursive
  aws s3api delete-bucket --bucket {{TallyToolTerraform}}

create-terraform-dynamodb:
  aws dynamodb create-table \
    --table-name {{TallyToolTerraform}} \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

delete-terraform-dynamodb:
  aws dynamodb delete-table --table-name {{TallyToolTerraform}}

setup-terraform: create-terraform-bucket create-terraform-dynamodb
destroy-terraform: delete-terraform-bucket delete-terraform-dynamodb

init-infra:
  cd the-infra; terraform init

apply-infra:
  cd the-infra; terraform apply

destroy-infra:
  cd the-infra; terraform destroy

setup: setup-terraform init-infra apply-infra
destroy: destroy-infra destroy-terraform
