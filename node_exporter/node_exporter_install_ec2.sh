#!/bin/bash
# Installation script of Prometheus's node exporter usabla by any EC2 Linux
# Will by installed in /opt/node_exporter--amd64

# Define release of prometheus and deduce installation directory
PROGRAM=node_exporter
##RELEASE=${NODE_EXPORTER_RELEASE:-0.17.0}
INSTALLDIR="/tmp/node_exporter_installation"
##CURDIR=$(dirname $0)
URL_DL_GITHUB="wget https://github.com/GitHubTamediaEis/CONF-Prometheus/raw/v0.3/node_exporter/"
FILETODL="install.sh start_stop_node_exporter.sh uninstall.sh"

[ ! -d $INSTALLDIR ] && mkdir $INSTALLDIR 
cd $INSTALLDIR
pwd
ls -l
