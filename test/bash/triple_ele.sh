#!/bin/bash

. functions.sh

#must be called after quote functions.sh
section_title ': act as placeholder, and ${1? "Usage: $0 argments, Exit if no parameter"'
para=${1:-100}
: ${para?"Usage: $0: arguments"}
echo $para
