#!/bin/bash

NAME=$1
DIR=$(dirname $0)
$DIR/download.rb opml "$1"
open -W "$1.opml"
$DIR/delete.rb -y "$1"
$DIR/upload.rb "$1.opml"
# Optional:
# rm "$1.opml"