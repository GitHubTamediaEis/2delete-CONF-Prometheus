#!/bin/bash

[ -f ecosystem-versions.sh ] && . ecosystem-versions.sh
[ -f prometheus/install.sh ] && bash prometheus/install.sh
[ -f alertmanager/install.sh ] && bash alertmanager/install.sh
[ -f node_exporter/install.sh ] && bash node_exporter/install_update.sh
[ -f cloudwatch_exporter/install.sh ] && bash cloudwatch_exporter/install.sh
[ -f yace_cloudwatch_exporter/install.sh ] && bash yace_cloudwatch_exporter/install.sh
[ -f alertsnitch/install.sh ] && bash alertsnitch/install.sh

