#!/bin/bash
#
# bash script to sync local files to external USB-key
# AND off-site backup on DigitalOcean Spaces storage
# using s3cmd cli as AWS storage-compatible DO Spaces
#
# see following links for details:
# - DO Spaces: https://docs.digitalocean.com/products/spaces/
# - DO Spaces using s3cmd: https://docs.digitalocean.com/products/spaces/reference/s3cmd-usage/
# - s3cmd usage: https://s3tools.org/usage
#
# Written by: Jacob Isreal, Isreal Consulting LLC (www.icllc.cc)
#             jisreal@icllc.cc
#
# Last updated: 09-09-2024
#

# VARIABLES
#---------------------------------------------------------------------------------------------------
# full path to external USB backup drive mount for backups, no trailing / slashes
usbdrive="/usbdrive/path"
# full path to user home dir, no trailing / slashes
userhome="/home/user"
# DigitalOcean Spaces or s3 storage name and folder root, no preceeding OR trailing / slashes
cloudpath="space/pc-backup"
# logfile filename (will be placed in $userhome as defined above)
# DON'T FORGET to setup logfile rotation for this file, or delete regularly as status is appended
logfile="sync.log"
#---------------------------------------------------------------------------------------------------

# create date-stamp for log file, update user, and append status to log file
export NOW=$(date +%Y-%m-%d--%H-%M-%S)

echo " "
echo "* BACKUP / SYNC Started *"
echo " "
echo "Syncing Local files (docs, pics, music, email...)"
echo "   > syncing to device: USB-BACKUP ($usbdrive)"
echo " "
echo "${NOW} : BEGIN SYNC local files to USB-BACKUP ($usbdrive).">> $userhome/$logfile

# use rsync to sync local files with external USB or mounted drive, with
# automatic removal of deleted files (from local machine) and show progress
# for local file sync using flags --info=progress2 --no-i-r
echo "   - syncing folders..."
rsync -a --exclude-from='sync-local-exclude.txt' $userhome/ $usbdrive --delete --info=progress2 --no-i-r
echo " "
echo "* Files Synced to USB-BACKUP (usbdrive)."
# write to log file, append - BE SURE to setup log file rotation!
export NOW1=$(date +%Y-%m-%d--%H-%M-%S)
echo "${NOW1} : Finished local file sync to USB-BACKUP.">> $userhome/$logfile

# Sync to DigitalOcean Spaces cloud storage using s3cmd with recursion
# and delete locally removed files from cloud, plus show progress
echo " "
echo "* Preparing to sync to Cloud..."
echo "   > syncing to cloud: DO Spaces"
echo " "
export NOW2=$(date +%Y-%m-%d--%H-%M-%S)
echo "${NOW2} : Begin Local files synced to DO Spaces cloud...">> $userhome/$logfile

echo "   - syncing Desktop..."
s3cmd sync $userhome/Desktop/ s3://$cloudpath/desktop/ --recursive --delete-removed
echo " "
echo "   - syncing Documents..."
s3cmd sync $userhome/Documents/ s3://$cloudpath/documents/ --recursive --delete-removed
echo " "
echo "   - syncing Pictures..."
s3cmd sync $userhome/Pictures/ s3://$cloudpath/pictures/ --recursive --delete-removed
echo " "
echo "   - syncing Music..."
s3cmd sync $userhome/Music/ s3://$cloudpath/music/ --recursive --delete-removed
echo " "
echo "   - syncing Videos..."
s3cmd sync $userhome/Videos/ s3://$cloudpath/videos/ --recursive --delete-removed
echo " "
echo "   - syncing Thunderbird Email... "
s3cmd sync $userhome/.thunderbird/ s3://$cloudpath/thunderbird/ --recursive --delete-removed
echo " "
#echo " - Setting Private permissions..."

# OPTIONAL: set ACL to all files in DO Spaces cloud backup to PRIVATE
#s3cmd setacl s3://$cloudpath/ --acl-private --recursive

export NOW3=$(date +%Y-%m-%d--%H-%M-%S)
echo "${NOW3} : Finished Local files sync to DO Spaces cloud...">> $userhome/$logfile
echo "${NOW3} : SYNC COMPLETE!">> $userhome/$logfile
echo "----- ">> $userhome/$logfile

echo "* All syncing of local files to offline storage and cloud complete."
echo " "
echo "----- "

