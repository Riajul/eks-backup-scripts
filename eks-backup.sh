#!/bin/bash

# Specify your AWS region
AWS_REGION="<>" #EX: us-east-2

# Specify your Cluster name
CLUSTER_NAME="<>" #EX: prod-cluster

#Env
ENV_VARSION="<>" #Ex: prod-1-23

# List of instance IDs
INSTANCE_IDS=(<>) #Ex: "i-068a" "i-068b" "i-04b"

# Describe EKS cluster and save to YAML file
aws eks describe-cluster --name $CLUSTER_NAME --region $AWS_REGION --query "cluster" --output yaml > eks-cluster-config-$ENV_VARSION.yaml
echo "$CLUSTER_NAME cluster info exported"

# Copy EKS cluster config file to S3
aws s3 cp eks-cluster-config-$ENV_VARSION.yaml <S3 URI> #s3://eks-backup/eks-backups-prod/$CLUSTER_NAME/

# List EKS worker node groups and save to YAML file
aws eks list-nodegroups --cluster-name $CLUSTER_NAME --region $AWS_REGION --query "nodegroups" --output yaml > eks-worker-nodes-$ENV_VARSION.yaml
echo "$CLUSTER_NAME worker info exported"

# Copy EKS worker node groups file to S3
aws s3 cp eks-worker-nodes-$ENV_VARSION.yaml <S3 URI> #s3://eks-backup/eks-backups-prod/$CLUSTER_NAME/

# Describe EBS volumes attached to specified instances and save to YAML file
aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$INSTANCE_IDS --query "Volumes" --output yaml > eks-ebs-volumes-$ENV_VARSION.yaml
echo "$CLUSTER_NAME EBS info exported"

# Copy EBS volumes file to S3
aws s3 cp eks-ebs-volumes-$ENV_VARSION.yaml <S3 URI> #s3://eks-backup/eks-backups-prod/$CLUSTER_NAME/
