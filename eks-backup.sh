#!/bin/bash

# Specify your AWS region EX: us-east-2
AWS_REGION="<>"

# Specify your Cluster name EX: prod-cluster
CLUSTER_NAME="<>"

#Env EX: prod-1-23
ENV_VARSION="<>"

# List of instance IDs EX: "i-068a" "i-068b" "i-04b"
INSTANCE_IDS=(<>)

# Describe EKS cluster and save to YAML file
aws eks describe-cluster --name $CLUSTER_NAME --region $AWS_REGION --query "cluster" --output yaml > eks-cluster-config-$ENV_VARSION.yaml
echo "$CLUSTER_NAME cluster info exported"

# Copy EKS cluster config file to S3 EX: s3://eks-backup/eks-backups-prod/$CLUSTER_NAME/
aws s3 cp eks-cluster-config-$ENV_VARSION.yaml <S3 URI>

# List EKS worker node groups and save to YAML file
aws eks list-nodegroups --cluster-name $CLUSTER_NAME --region $AWS_REGION --query "nodegroups" --output yaml > eks-worker-nodes-$ENV_VARSION.yaml
echo "$CLUSTER_NAME worker info exported"

# Copy EKS worker node groups file to S3 s3://eks-backup/eks-backups-prod/$CLUSTER_NAME/
aws s3 cp eks-worker-nodes-$ENV_VARSION.yaml <S3 URI>

# Describe EBS volumes attached to specified instances and save to YAML file
aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$INSTANCE_IDS --query "Volumes" --output yaml > eks-ebs-volumes-$ENV_VARSION.yaml
echo "$CLUSTER_NAME EBS info exported"

# Copy EBS volumes file to S3 EX: s3://eks-backup/eks-backups-prod/$CLUSTER_NAME/
aws s3 cp eks-ebs-volumes-$ENV_VARSION.yaml <S3 URI>
