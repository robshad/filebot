#!/bin/bash
readlink_cmd='readlink'
date_cmd='date'

# set path and name variables
this_path=$(readlink -f $0)  ## Path of this file including filename
dir_name=`dirname ${this_path}`     ## Parent directory of this file WITHOUT trailing slash

# inlcude default config settings
if [ ! -f "$dir_name/filebot.cfg" ] ; then
    echo "No config file was found. Exiting."
    exit 1
else
    source "$dir_name/filebot.cfg"
fi

filebot -script fn:amc -extract --log-file /config/amc.log -non-strict /input --output /output --def "seriesFormat=$movieFormat" "movieFormat=$tvFormat" "musicFormat=$musicFormat" $filebot_args