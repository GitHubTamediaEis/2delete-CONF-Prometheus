# ----------------------------------------------------------------
#   Small script to monitor process numbers
# ----------------------------------------------------------------
# 21.05.2019 Laurent
#
metric_prefix=node_
dir_collector=/var/lib/node_exporter/textfile_collector/

# List of prcess to check
list_proc="
/opt/cloudwatch_exporter
/opt/node_exporter
/opt/alertmanager
/opt/prometheus
/opt/yace_cloudwatch_exporter
"

out_f=$dir_collector`basename $0`.prom
[[ -f $out_f ]] && rm $out_f

for p in $list_proc
do
    proc_name=`echo $p |sed 's/.*\///'`
    count_proc=`ps -ef|grep -v grep|grep $p|wc -l`
    echo $metric_prefix"script_count_process{proc_name=\"$proc_name\"} $count_proc" >> $out_f
done
