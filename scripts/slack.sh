#!/bin/bash

channel_name=$1
message=$2
file_name=${3:-}

token=$SLACK_TOKEN

text="[$(hostname -s)] $message"

if [ -z $file_name ]; then
  curl -d "text=$text" -d channel="$channel_name" -H "Authorization: Bearer $token" -X POST https://slack.com/api/chat.postMessage > /dev/null
else
  curl -F file=@"$file_name" -F filename="$file_name" -F "initial_comment=$text" -F channels="$channel_name" -H "Authorization: Bearer $token" https://slack.com/api/files.upload > /dev/null
fi

