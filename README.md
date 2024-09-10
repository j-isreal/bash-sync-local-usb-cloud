# bash-sync-local-usb-cloud
BASH script to sync local files to external USB-key AND off-site backup on cloud using s3cmd cli as AWS storage-compatible DO Spaces

## 1. Setup s3cmd and cloud storage space
**FIRST**, either comment out the ```s3cmd``` lines, or setup s3cmd.

s3cmd is available from the linux repositories.  You can use any AWS (Amazon)-compatible cloud storage service.

I prefer DigitalOcean Spaces - it's only $5.00 a month for 250GB of storage.

Here's a $250 credit with them:

[![DigitalOcean Referral Badge](https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg)](https://www.digitalocean.com/?refcode=7774aa9a2bfa&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

### 1a. Ensure your s3cfg is configured and you can access the cloud storage
You will need your API key and secret to configure s3cmd.

Visit [DigitalOcean](https://docs.digitalocean.com/products/spaces/reference/s3cmd/) for complete instructions.


Use the following to setup s3cmd:
```
s3cmd --configure
```


See following links for details:
- DO Spaces: https://docs.digitalocean.com/products/spaces/
- DO Spaces using s3cmd: https://docs.digitalocean.com/products/spaces/reference/s3cmd-usage/
- s3cmd usage: https://s3tools.org/usage

## 2. Update variables in script and exclude file
**NEXT**, update all the variables at the top of the script - it will not work if you do not update the values.

**To exclude** files or folders from the sync, update the ```sync-local-exclude.txt``` file.

- Enter each excluded file or folder one a separate line.
- This backup script uses rsync to sync everything from the user's home folder - _you must exclude_ what you don't want backed up (like your Downloads folder).
 


## 3. Make script executable and run
Make the file executable by:
```
chmod +x sync-local.sh
```
Then run with:
```
./sync-local.sh
```

Remember to rotate log files, as they append to the logfile.


### View on website
View on my website [www.jinet.us](https://www.jinet.us/dev/scripts/bash-s3cmd-nightly-backup/)

Copyright &copy; 2024 Jacob Eiler, Isreal Consulting, LLC.  All rights reserved.
