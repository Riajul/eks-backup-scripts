#!/bin/bash

# Specify your AWS region
AWS_REGION="<>" #Ex: us-east-2

# List of instance IDs for which to create snapshots
INSTANCE_IDS=(<>) #Ex: "i-067a" "i-06fb" "i-04bc"

# Iterate through the list of instance IDs and create snapshots for their volumes
for instance_id in "${INSTANCE_IDS[@]}"
do
    volume_ids=($(aws ec2 describe-volumes --region $AWS_REGION --filters "Name=attachment.instance-id,Values=$instance_id" --query "Volumes[].VolumeId" --output text))
    
    for volume_id in "${volume_ids[@]}"
    do
        snapshot_id=$(aws ec2 create-snapshot --region $AWS_REGION --volume-id $volume_id --description "Snapshot for volume $volume_id on instance $instance_id" --query "SnapshotId" --output text)
        if [ $? -eq 0 ]; then
            echo "Snapshot created for volume $volume_id on instance $instance_id: $snapshot_id"
        else
            echo "Error creating snapshot for volume $volume_id on instance $instance_id"
        fi
    done
done
