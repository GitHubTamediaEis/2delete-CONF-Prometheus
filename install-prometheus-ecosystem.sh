#!/bin/bash

[ -f ecosystem-versions.sh ] && . ecosystem-versions.sh
[ -f prometheus/install.sh ] && bash prometheus/install.sh
[ -f node_exporter/install.sh ] && bash node_exporter/install.sh
