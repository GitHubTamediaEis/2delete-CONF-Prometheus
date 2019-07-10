# --------------------------------------------------
#    Simple report script about notification
# --------------------------------------------------
# 24.05.2019 Laurent
#


metric_prefix=node_
dir_collector=/var/lib/node_exporter/textfile_collector/

out_metric_f=$dir_collector`basename $0`.prom

tmpf=/tmp/out_report_notification.txt
tmp_to_f=/tmp/out_report_notification_to.txt
tmp_metric=/tmp/out_report_notification_metric.txt
tmp_metric_cust=/tmp/out_report_notification_metric_cust.txt
logf=/var/log/report_mail_sent.log

[[ ! -f $logf ]] && touch $logf
[[ -f $tmpf ]] && rm $tmpf
[[ -f $tmp_metric ]] && rm $tmp_metric
[[ -f $tmp_metric_cust ]] && rm $tmp_metric_cust

for id in `cat /var/log/maillog |grep -i status=sent|egrep -vi 'to=<(root|laurent)'|sed 's/.*smtp\[[0-9]*\]: //'|sed 's/: .*//'`
do
        not_date=`grep -i $id /var/log/maillog|grep status=sent|sed 's/ ip-.*//'`
        not_to=`grep -i $id /var/log/maillog|grep status=sent|sed 's/.*to=<//'|sed 's/>,.*//'`
        not_subject=`grep -i $id /var/log/maillog|grep -i "header Subject:"|sed 's/.*header Subject: //'|sed 's/ from localhost.*//'`

        ##echo "id = $id, $not_date, $not_to, $not_subject"

        echo "$not_subject"|sed 's/\[FIRING:[0-9]*\] *//'| sed 's/\[RESOLVED\] *//' >> $tmpf

        if [ `echo $not_subject | grep "Yace restarted"| wc -l` -lt 1 ]
        then
                ##echo "$not_date $id $not_to $not_subject"

                is_record_exist=`grep -u "$id" $logf|grep "$not_date"|wc -l`

                ##echo "is_record_exist = $is_record_exist"
                if [ $is_record_exist -eq 0 ]
                then
                        echo "$not_date $id $not_to $not_subject" >> $logf

                        # Add metric as customised metrics
                        #not_date_epoch=`date -d "$not_date" +"%s"`
                        #not_subject_short=`echo $not_subject |cut -f 1,2 -d ' '|sed 's/\s*//'`
                        #echo "script_notification{mail_group=\"$not_to\", mail_short_subject=\"$not_subject_short\"} 1" >> $tmp_metric_cust
                fi
        fi

        [[ `cat $tmp_to_f|grep $not_to|wc -l` -eq 0 ]] && echo $not_to | egrep -iv '[a-z] [a-zA-Z]' && echo $not_to >> $tmp_to_f

done

for mail_to in `cat $tmp_to_f`
do
        curM=`date +%B`
        curD=`date +%d`
        curH=`date +%H`

        cat $logf|grep -i $mail_to|egrep  -i "$curM "|grep " $curD "| grep " $curH"
        num_not=`cat $logf|grep -i $mail_to|egrep -i "$curM "|grep " $curD "| grep " $curH"|wc -l`
        echo "script_number_of_notification{mail_group=\"$mail_to\"} $num_not" >> $tmp_metric
done

cp -p $tmp_metric $out_metric_f
