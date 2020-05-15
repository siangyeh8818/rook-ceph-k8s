#!/bin/bash

backup_dir=/root/ceph-backup-$(date "+%Y%m%d-%H%M%S")
mkdir -p $backup_dir

start_time=$(date +"%s")

download2() {
  echo "------List all buckets name ----------"
  backets_array=$(s3cmd ls | awk '{print $3}')
  echo "------List backets_array  ----------"
  for bucket in $backets_array
  do
     echo "Bucket name : $bucket"
     s3cmd sync $bucket "$backup_dir/${bucket:5}"
  done
}

download2

end_time=$(date +"%s")
duration=$(($end_time - $start_time))
echo "Spent time ${duration}s"
