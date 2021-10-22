# savedbb

Save Database to Backblaze

## Requirements

- pg_dump - postgres database dumper
- 7z - 7zip file compress / decompression `apt install p7zip-full`
- b2 - Backblaze b2 client from https://www.backblaze.com/b2/docs/quick_command_line.html

**Note**

Put b2 in common path so it is accessible e.g. `/usr/bin`

## Installation

Execute as postgres user

1. Create backup dir

```bash
mkdir -p /backups/db
```

2. Get script

```bash
mkdir ~/bin
cd ~/bin
wget https://raw.githubusercontent.com/ninja-software/savedbb/master/savedbb.sh
chmod +x savedbb.sh
```

3. Download, edit, save .savedbb.env file, set permission 600

```bash
chmod 600 .savedbb.env
```

4. Run as cron job (as postgres user, otherwise need to specify user in pg_dump)

```bash
crontab -e

# m h  dom mon dow   command
0 10 * * * . $HOME/.savedbb.env; $HOME/bin/savedbb.sh >> $HOME/bkup.log
```
