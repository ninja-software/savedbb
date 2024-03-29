#!/bin/bash

# savedbb 
# A simple script to perform postgres db backup and copy to offsite

# requirement:
# backblaze b2 client from https://www.backblaze.com/b2/docs/quick_command_line.html

# sanity check
# make sure /backups/db exists
if [ ! -d /backups/db ]
then
  echo "dir /backups/db not exists"
  exit 1
fi
# make sure b2 exist
if ! command -v b2 &> /dev/null
then
  echo "b2 not exist"
  exit 2
fi
# make sure 7z exists
if ! command -v 7z &> /dev/null
then
  echo "7z not exist"
  exit 3
fi
# make sure pg_dump exists
if ! command -v pg_dump &> /dev/null
then
  echo "pg_dump not exist"
  exit 4
fi

# environment variables or default

# db settings (change me, or use export variable)
DBNAME=${DBNAME:="testdb"}

# 7z password (change me, or use export variable)
PASSWD=${PASSWD:="testpass"}

# backblaze b2 settings (change me, or use export variable)
BB_KEYID=${BB_KEYID:="00000"}
BB_KEYNAME=${BB_KEYNAME:="test-backup"}
BB_APPKEY=${BB_APPKEY:="test-key"}
BB_ENDPOINT=${BB_ENDPOINT:="s3.123.backblazeb2.com"}
BB_BUCKET=${BB_BUCKET:="test-bucket"}

# make sure db name is supplied
if [ "$DBNAME" = "testdb" ]; then
  echo "DBNAME not supplied"
  exit 5
fi

# make sure 7z password is supplied
if [ "$PASSWD" = "testpass" ]; then
  echo "PASSWD not supplied"
  exit 6
fi

# make sure b2 account is setup
b2 authorize-account ${BB_KEYID} ${BB_APPKEY}

# naming files by time
DATE=$(date +"%Y%m%d%H%M")
SQLPREFIX="${DBNAME}_${DATE}"

# go to work dir
cd /backups/db

# delete any local files older than 100 days
find /backups/db/* -type f -iname "*.7z" -mtime +100 -delete
find /backups/db/* -type f -iname "*.uploaded" -mtime +100 -delete

# dump db and compress and encrypt
pg_dump ${DBNAME} | 7z a -y -si -mx1 -mmt1 -bd -p"${PASSWD}" "${SQLPREFIX}.sql.7z"

# upload any files not yet uploaded
find * -type f -iname "*.7z" -exec [ ! -f "{}.uploaded" ] \; -exec b2 upload_file ${BB_BUCKET} "{}" "database/{}" \; -exec touch "{}.uploaded" \;

echo "Backup completed successfully"

exit 0
