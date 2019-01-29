#!/bin/bash
# Installation script of Prometheus's node exporter usabla by any EC2 Linux
# install v1.0 25.01.2019

# Define release of prometheus and deduce installation directory
PROGRAM=node_exporter
INSTALLDIR="/tmp/node_exporter_installation"
URL_DL_GITHUB="https://github.com/GitHubTamediaEis/CONF-Prometheus/raw/v0.3/node_exporter/"
FILETODL="install.sh start_stop_node_exporter.sh uninstall.sh"
INSTALLSH="install.sh"

# if install dir exist --> remove it
[ -d $INSTALLDIR ] && rm -rf $INSTALLDIR

# Create install dir
[ ! -d $INSTALLDIR ] && mkdir $INSTALLDIR

# Download 'package'
cd $INSTALLDIR

for shfile in $FILETODL
do
    urldl=$URL_DL_GITHUB$shfile
    wget $urldl
    chmod 755 $shfile

done

# Install 'package'
./$INSTALLSH

# remove installation dir
cd ..
[ -d $INSTALLDIR ] && [ -f $INSTALLDIR/$INSTALLSH ] &&  rm -rf $INSTALLDIR

