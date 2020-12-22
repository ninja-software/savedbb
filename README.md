# savedbb

Save Database to Backblaze

## Requirements

- pg_dump - postgres database dumper
- 7z - 7zip file compress / decompression
- b2 - Backblaze b2 client from https://www.backblaze.com/b2/docs/quick_command_line.html

**Note**

Put b2 in common path so it is accessible e.g. `/usr/bin`

## Installation

1. Create backup dir

```bash
mkdir /backups
```

2. Get script

```bash
mkdir ~/bin
cd ~/bin
wget https://raw.githubusercontent.com/ninja-software/savedbb/master/savedbb.sh
chmod +x savedbb.sh
```

3. Download, edit, save .savedbb.env file

4. Run as cron job

```bash
crontab -e

# m h  dom mon dow   command
0 10 * * * source $HOME/.savedbb.env; $HOME/bin/savedbb.sh >> $HOME/bkup.log
```
