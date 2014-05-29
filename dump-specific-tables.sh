#!/bin/bash

export PATH=/bin:/usr/bin

DBHOST=db.dcolon.net
DBUSER=dbuser
DBPASSWD=ABCD1234
DATABASE=somedb
TABLES="table1 table2 table3"
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")
S3BUCKET="s3://net.dcolon.backups/mysql/$YEAR/$MONTH/$DAY/"
DUMPFILE="/storage/backups/dump.sql"

mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWD $DATABASE $TABLES > $DUMPFILE 

# if successful copy dump.sql to S3            
if [ $? -eq 0 ]; then
    s3cmd put $DUMPFILE $S3BUCKET
fi

mv $DUMPFILE $DUMPFILE.$YEAR$MONTH$DAY
