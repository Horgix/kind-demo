# This script has to be sourced, NOT executed, so it can export environment
# variables to your running terminal

# It is hugely reliant on my own setup based on `pass`
# (https://www.passwordstore.org/) but can give you some idea of what you'll
# need in order to reproduce what is being done in this demo repository

# For Terraform (see infrastructure/terraform/README.md) :
export SCALEWAY_ORGANIZATION=`pass xebia/scaleway/api-organization`
export SCALEWAY_TOKEN=`pass xebia/scaleway/api-secret-key`
export AWS_ACCESS_KEY_ID=`pass xebia/aws/mine/key-id`
export AWS_SECRET_ACCESS_KEY=`pass xebia/aws/mine/key-secret`

# For Ansible dynamic inventory
export SCW_TOKEN=`pass xebia/scaleway/api-secret-key`

# For Packer builder
export SCALEWAY_API_TOKEN=`pass xebia/scaleway/api-secret-key`
