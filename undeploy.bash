#!/bin/bash

echo "...Undeploying environment"

while read stackName
do

stackID=$(aws cloudformation describe-stacks   --stack-name ${stackName} --query Stacks[].StackId --output text)

echo "...Deleting stack - ${stackName}"
aws cloudformation delete-stack   --stack-name ${stackName}

echo "...waiting for stack to DELETE COMPLETE"
aws cloudformation wait stack-delete-complete --stack-name ${stackID}

done << STACKS
instances
baseNetwork
STACKS

echo "...Undeployment Done"
