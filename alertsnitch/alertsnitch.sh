#!/bin/bash
# Exit if file doesn't end with .sh.  This is
# because cfn-hub creates a backup file in the cron.hourly dir
EcsLoadBalancer=$1
grep  'alertsnitch' '/etc/prometheus/alertmanager.yml'
if [[  $? != 0 ]]; then
    sed -i "/^inhibit_rules:.*/i - name: 'alertsnitch'\n  webhook_configs:\n    - url: http://"$EcsLoadBalancer"/webhook2" "/etc/prometheus/alertmanager.yml"
    service alertmanager reload
    exit 0
fi
