#!/bin/bash
yum install -y python-pip
pip install s3cmd

access_key=$(kubectl exec -ti $(kubectl get po -n rook-ceph | grep rook-ceph-tools | awk '{print $1}') -n rook-ceph radosgw-admin -- user info --uid=my-user | jq -rj .keys[0].access_key)
secret_key=$(kubectl exec -ti $(kubectl get po -n rook-ceph | grep rook-ceph-tools | awk '{print $1}') -n rook-ceph radosgw-admin -- user info --uid=my-user | jq -rj .keys[0].secret_key)
endpoint=$(kubectl get svc rook-ceph-rgw-my-store -n rook-ceph -o json | jq -rj '.spec.clusterIP')

ACCESS_KEY=$access_key SECRET_KEY=$secret_key ENDPOINT=$endpoint envsubst < s3cfg.tpl > ~/.s3cfg

yum install epel-release
yum install python36
python3 -m ensurepip
pip3 install --upgrade pip

pip3 install aws-shell

mkdir -p ~/.aws
cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = $access_key
aws_secret_access_key = $secret_key
EOF

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

nvm --version

nvm install v8.15.1
