# CHECK_MINS: INT
# SMTP: STRING
# SMTP_PORT: INT
# RECIPIENT: STRING
# JOB_ID: STRING
# OPERATION: archive / purge


ARCHIVE_LOG=/app/archive.log
ERROR_LOG=/app/error.log
#DB_REPO_CONFIG=/app/config/repositories.yml

# Assign Default Value
#RETURN_CODE=`nc -z -w 3 $SMTP $SMTP_PORT &> /dev/null && echo 0 || echo 1`
#if [ $RETURN_CODE -ne 0 ];then
#  echo "The SMTP is not alive!"
#  exit 1
#else
#  echo "SMTP is alive......"
#fi

#DB_LIST=`cat $DB_REPO_CONFIG | grep 'database:' | awk '{print $2}'`
DB_LIST="$SRC_MYSQL_DATABASE $DST_MYSQL_DATABASE"
SERVICE=`echo $DB_LIST | sed 's/ / <> /'`
CHECK_MINS=${CHECK_MINS:='15'}

SUBJECT="[Sev.2] [$ENV] Chronos error log alert ( $SERVICE )"


SEND_MAIL()
{
  #cat $ERROR_LOG | mailx -S smtp=${SMTP}:25 -r noreply@gamesourcecloud.com -s "$SUBJECT" -v "$RECIPIENT"
  ruby /app/scripts/alert.rb "${ERROR_LOG}" "${SMTP}" "${SUBJECT}" "${RECIPIENT}" "noreply@gamesourcecloud.com" "${SERVICE}" "${ENV}"
}

CHECK_ARCHIVE_ERROR()
{

    # logrotate
    cp $ARCHIVE_LOG ${ARCHIVE_LOG}.1
    cat /dev/null > $ARCHIVE_LOG

    # check error and send alert
    cat ${ARCHIVE_LOG}.1 | grep -E 'WARN -- :|ERROR -- :' | sed  's/\[.*\]//g' | awk -F ',' '{count[$2]++} END {for (a in count) print a,":", count[a]}' | sort -rt: -nk2 > $ERROR_LOG
#    cat ${ARCHIVE_LOG}.1 | sed  's/\[.*\]//g'| awk -F ',' '$1 != "I" { print $1,",",$2 }' | awk -F ',' '{count[$2]++} END {for (a in count) print a,":", count[a]}' > $ERROR_LOG

    if [ `cat $ERROR_LOG | wc -l` -gt 0  ];then
      #SEND_MAIL
      cat /dev/null > $ERROR_LOG
    fi


}

#################
###   Main   ####
#################

# check migration scipt can be run
bundle exec chronos migration

if [ $? -eq 1 ];then
  exit 1

else
  if [ ! -z ${TESTING+x} ];then
    echo "Testing........."
    sleep 10000000000;
    exit 0
  else
    echo "Running........."
  fi

  # run specific job if the job_id / operation is set
  if [ ! -z ${JOB_ID+x} ];then
    bundle exec chronos jobs id:$JOB_ID >> $ARCHIVE_LOG 2>&1 &
  elif [ ! -z ${OPERATION+x} ];then
    bundle exec chronos jobs $OPERATION >> $ARCHIVE_LOG 2>&1 &
  else
    bundle exec chronos jobs >> $ARCHIVE_LOG 2>&1 &
  fi



  # Check at the first time to ensure no error until the next check time
  sleep 60
  CHECK_ARCHIVE_ERROR

  # cronjob - logrotate and send mail if any error is capture
  while true;
  do
    sleep $(( 60 * CHECK_MINS ))
    CHECK_ARCHIVE_ERROR
  done


fi
