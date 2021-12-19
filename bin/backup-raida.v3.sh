#!/bin/bash

# Change the DBNAME and BKFILE as yours.
DBNAME="cc_raida"
BKFILE="$DBNAME#13.`date +%y%m%d`"
CONTNAME="nginx_mysql_db_1"
HOSTDIR="/root/ADIAR/Nginx_MySQL"
BKDIR="db/backup"
KEEP=2


[ -d $HOSTDIR ] || mkdir $HOSTDIR
cd $HOSTDIR
start_s=$(date +%s)
echo "*********** START `date "+%F@%T"` **************"

# Full Backup
echo "-> Back up Full DB "
docker exec $CONTNAME sh -c "exec mysqldump -uroot -p\"\$MYSQL_ROOT_PASSWORD\" --ignore-table=$DBNAME.ans --ignore-table=$DBNAME.transfer --ignore-table=$DBNAME.fixit_log $DBNAME" > $BKDIR/$BKFILE-data.sql
docker exec $CONTNAME sh -c "exec mysqldump -d --single-transaction -uroot -p\"\$MYSQL_ROOT_PASSWORD\" $DBNAME" > $BKDIR/$BKFILE-schema.sql

retval=$?

if [ $retval -eq 0 ];then
    echo "... [success]"
else
    echo "... [failure]**"
    exit 1
fi

# Compress the files
echo "-> Compress the dump file "
gzip -f $HOSTDIR/$BKDIR/$BKFILE*.sql

retval=$?
if [ $retval -eq 0 ];then
    echo "... [success]"
else
    echo "... [*failure*]"
    exit 1
fi

# Purge the old files
echo "-> Purge the old files"
ls_files=($(ls -lt $HOSTDIR/$BKDIR/$DBNAME* | awk -F ' ' '{print $9}'))
len=${#ls_files[@]}
i=$KEEP
while (($i < $len));do
        #echo "Remove ${ls_files[$i]}"
        rm -vf "${ls_files[$i]}"
        let i++
done


end_s=$(date +%s)
elapsed=$(( end_s - start_s  ))
echo 
echo "Elapsed: $elapsed seconds"
echo "Output File: "
ls -l $HOSTDIR/$BKDIR/$BKFILE*.gz
echo "*********** END `date "+%F@%T"` **************"
echo
