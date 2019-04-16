access_key=$(kubectl get secret -n rook-ceph rook-ceph-object-user-my-store-my-user -o json | jq .data.AccessKey | cut -d '"' -f 2 | base64 --decode)
secret_key=$(kubectl get secret -n rook-ceph rook-ceph-object-user-my-store-my-user -o json | jq .data.SecretKey | cut -d '"' -f 2 | base64 --decode)
ceph_rgw_ip=$(kubectl get svc -n rook-ceph | grep rgw | awk '{print $3}')
ceph_rgw_endpoint=http://${ceph_rgw_ip}:80

backup_path=$(pwd)"/backup"
mkdir $backup_path

start_time=$(date +"%s")

bucket_list=($(aws s3 ls --endpoint ${ceph_rgw_endpoint} | awk '{print $3}'))
echo ${bucket_list[2]}
for bucket_name in ${bucket_list[@]}
do
    echo $bucket_name
    aws s3 cp --recursive --endpoint http://${ceph_rgw_ip}:80 s3://${bucket_name} "${backup_path}/${bucket_name}"
done

end_time=$(date +"%s")
duration=$(($end_time - $start_time))
echo "Spent time ${duration}s"
