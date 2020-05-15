#!/bin/bash

data_folder=$1
check=$2

start_time=$(date +"%s")

import() {
  echo "------List folder ----------"
  dir=$(ls -l $data_folder |awk '/^d/ {print $NF}')
  for i in $dir
  do
   echo "Bucket name: $i"
   if [ "$check" != "true" ]
   then
     echo "-------- Debug model ---------"
     echo "s3cmd sync $data_folder/$i/* s3://$i/"
   else
     echo "-------- Real model ---------"
     s3cmd sync $data_folder/$i/* s3://$i/
   fi
  done
}

import

end_time=$(date +"%s")
duration=$(($end_time - $start_time))
echo "Spent time ${duration}s"
