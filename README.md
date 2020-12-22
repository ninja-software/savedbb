# savedbb

Save Database to Backblaze

## Requirements

- pg_dump - postgres database dumper
- 7z - 7zip file compress / decompression
- b2 - Backblaze b2 client from https://www.backblaze.com/b2/docs/quick_command_line.html

## Installation

Create backup dir

```bash
mkdir /backups
```

Get script

```bash
mkdir ~/bin
cd ~/bin
wget https://raw.githubusercontent.com/ninja-software/savedbb/master/savedbb.sh
chmod +x savedbb.sh
```

Run as cron job

```bash
crontab -e

# crontab environment variables for savedbb
DBName="mydb"
PASSWD="7z-encrypt-pass"
BB_KEYID="00000"
BB_KEYNAME="test-backup"
BB_APPKEY="test-key"
BB_ENDPOINT="s3.123.backblazeb2.com"
BB_BUCKET="test-bucket"
# m h  dom mon dow   command
0 10 * * * $HOME/bin/savedbb.sh >> $HOME/bkup.log
```
