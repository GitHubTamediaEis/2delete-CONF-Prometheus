# ----------------------------------------------------
#   Check if yace_cloudwatch_exporter is running
#   - if not --> try to start it
# ----------------------------------------------------
# 24.05.2019 Laurent - Add it

logf=/var/log/workaround_check_start_yace.log
bool_err=0


printf "*** start $0 at " >> $logf
date >> $logf
/etc/init.d/yace_cloudwatch_exporter status >> $logf

# Get number of yace_cloudwatch_exporter process running
num_yace_proc=`/etc/init.d/yace_cloudwatch_exporter status|egrep 'running at [0-9]*' |wc -l`
echo "Number of running proc: $num_yace_proc" >> $logf

# If
if  [ $num_yace_proc -lt 1 ]
then
        bool_err=1

        echo "yace_cloudwatch_exporter is not running --> PROBLEM" >> $logf
        echo "### Yace log extract: tail -20 /var/log/yace_cloudwatch_exporter.log" >> $logf
        tail -20 /var/log/yace_cloudwatch_exporter.log >> $logf
        /etc/init.d/yace_cloudwatch_exporter start >> $logf

        sleep 2

        /etc/init.d/yace_cloudwatch_exporter start >> $logf
        echo "### Yace log extract:  tail -15 /var/log/yace_cloudwatch_exporter.log" >> $logf
        tail -15 /var/log/yace_cloudwatch_exporter.log >> $logf

        num_yace_proc=`/etc/init.d/yace_cloudwatch_exporter status|egrep 'running at [0-9]*' |wc -l`
        echo "Number of running proc: $num_yace_proc" >> $logf
        [[ $num_yace_proc -lt 1 ]] && echo "Process not started --> MAJOR ISSUE: Support is required" \
                || echo "Process is started --> OK for this time" >> $logf

else
        echo "yace_cloudwatch_exporter is running --> OK" >> $logf
fi


printf "*** End $0 at " >> $logf
date >> $logf

# Send notification
[[ $bool_err -gt 0 ]] && tail -70 $logf | mail -s "Yace restarted by $0" laurent.moix@tamedia.ch
