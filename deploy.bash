#!/bin/bash

echo "...Starting Env Creation"

while read stackName
do

echo "...Creating Stack - ${stackName}"

stackId=$(aws cloudformation create-stack \
    --stack-name ${stackName} \
    --template-body file://${stackName}.template \
    --parameters file://${stackName}Parameter.json | grep StackId |  awk -F 'StackId": ' '{print $2}' | cut -d'"' -f2)
echo "...Stack Name - ${stackId}"

if [ -z "${stackId}" ]; then
   echo "...Error in creating ${stackName}, Exiting"
   exit 1
fi

echo "...waiting for stack for CREATE COMPLETE"
aws cloudformation wait stack-create-complete \
    --stack-name ${stackId}

done << STACKS
baseNetwork
instances
STACKS

echo "...Finished Env Creation"