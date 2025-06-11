#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_ENABLE_GPU_SUPPORT=${gpu_support} >> /etc/ecs/ecs.config
curl -o /tmp/mount-s3.rpm https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm
yum install -y /tmp/mount-s3.rpm
mkdir -p /mnt/s3mount
mount-s3 ${bucket_name} --allow-other --allow-delete /mnt/s3mount
rm /tmp/mount-s3.rpm