## Prepare
aws-shell  
1. yum install -y python-pip  
2. pip install aws-shell  

## Backup  
1.在k8s master機器上執行backup.sh  
2.會在和backup.sh同目錄下產生backup的資料架和所有bucket的所有檔案  
3.將backup資料夾的內容做異地備份  

## Restore
1.在k8s master機器上執行restore.sh {backup_data_path}  
2.會將backup的資料用cp的方式寫回object storage  
