#!/usr/bin/env bash



myKey='Virginia'



echo ""
echo "creating vpc stack"
echo ""
aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name ecs-core-infrastructure --template-body file://core-infrastructure-setup.yml

aws cloudformation wait stack-create-complete --stack-name ecs-core-infrastructure

export CORE_STACK_NAME="ecs-core-infrastructure"
export vpc=$(aws cloudformation describe-stacks --stack-name $CORE_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`VpcId`].OutputValue' --output text)
export subnet_1=$(aws cloudformation describe-stacks --stack-name $CORE_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`PublicSubnetOne`].OutputValue' --output text)
export subnet_2=$(aws cloudformation describe-stacks --stack-name $CORE_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`PublicSubnetTwo`].OutputValue' --output text)


echo "vpc: $vpc"
echo "subnet1: $subnet_1"
echo "subnet2: $subnet_2"





STACK_NAME="PhotoPrism"
export password="xxxxx"


aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://photoprism.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=VPC,ParameterValue=$vpc ParameterKey=Subnet1,ParameterValue=$subnet_1 ParameterKey=Subnet2,ParameterValue=$subnet_2 ParameterKey=DatabasePassword,ParameterValue=$password ParameterKey=PhotoPrismAdminPassword,ParameterValue=$password

aws cloudformation wait stack-create-complete --stack-name PhotoPrism






