# Manual steps

1. Create an IAM user for tally tool with

- username `TallyToolAdmin`
- assign the `AdministratorAccess` permission to the user

Insert all the data in to the `password-store`
  1. `pass insert tally-tool/aws-url`
  2. `pass insert tally-tool/aws-username`
  3. `pass insert tally-tool/aws-password`

2. Create an `Access Key` for the AWS CLI

Insert all the data in to the `password-store`
  1. `pass insert tally-tool/access-key`
  2. `pass insert tally-tool/access-key-secret`

3. Create an SES smtp server

Get the `ses-server` smtp server addres
Get the `ses-username`
Get the `ses-password`
