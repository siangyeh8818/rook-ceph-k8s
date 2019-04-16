# -*- coding: UTF-8 -*-

import boto3
import os
import time
import threading

access_key = 'XR1HGRNICBY8DMW56PCI'
secret_key = 'OMixLGF0AvgyRDy4OxXrBUyrpxqlXqOFPu40kOyy'

# 建立練線物件，實際上還沒有連線
# 在後面呼叫func的時候才會真的建立連線
s3_client = boto3.client(
    's3',
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    endpoint_url='http://192.168.89.33:30526',
    use_ssl=False,               # uncomment if you are not using ssl
)

class DownloadS3BucketObject(threading.Thread):
    def __init__(self, bucket_name, object_key, base_path):
        threading.Thread.__init__(self)
        self.bucket_name = bucket_name
        self.object_key = object_key
        self.base_path = base_path

    def run(self):
        #s_time = time.time()
        separate_path = self.object_key.split('/')
        origin_file_path = '/'.join(separate_path[0:-1])
        download_file_path = self.base_path + '/' + self.bucket_name + '/' + origin_file_path
        download_file = self.base_path + '/' + self.bucket_name + '/' + self.object_key
        os.makedirs(download_file_path, exist_ok=True)
        s3_client.download_file(self.bucket_name, self.object_key, download_file)
        #print("finished download {}. {}".format(self.object_key, time.time()-s_time))


def main():
    start_time = time.time()
    # 取得所有的bucket並且列出來
    buckets = s3_client.list_buckets().get('Buckets', list())
    base_path = './backup'

    task_list = list()
    for bucket_data in buckets:
        for key in s3_client.list_objects(Bucket=bucket_data['Name']).get('Contents', list()):
            download_task = DownloadS3BucketObject(bucket_data['Name'], key['Key'], base_path)
            download_task.start()
            task_list.append(download_task)

    for task in task_list:
        task.join()

    end_time = time.time()
    print("Finished!!! Spend {}s.".format(end_time - start_time))


if __name__ == '__main__':
    main()


