#!/bin/sh
cd /opt/jekyll

ps -ef | grep /usr/local/bin/jekyll | awk '{print $2}' | xargs kill -9
