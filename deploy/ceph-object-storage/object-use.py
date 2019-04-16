# -*- coding: UTF-8 -*-

import boto
import boto.s3.connection

#access_key = 'FS7Y5GZ7DU1PFEZC63KK'
#secret_key = 'Fs7gAYPylW7Jdc5RG4NkVr8B8LjS4lxs1CLNQtHO'
access_key = 'XR1HGRNICBY8DMW56PCI'
secret_key = 'OMixLGF0AvgyRDy4OxXrBUyrpxqlXqOFPu40kOyy'

# 建立練線物件，實際上還沒有連線
# 在後面呼叫func的時候才會真的建立連線
conn = boto.connect_s3(
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    host='192.168.89.33',
    port=30526,
    is_secure=False,               # uncomment if you are not using ssl
    calling_format=boto.s3.connection.OrdinaryCallingFormat(),
)

# 建立一個新的bucket
conn.create_bucket("james")

# 取得所有的bucket並且列出來
for bucket in conn.get_all_buckets():
    print(bucket)

