#!/bin/sh
cd /opt/jekyll
jekyll server --watch --detach --trace >> ./log/jekyll.out
