# !/bin/sh

dirname="$(dirname "$0")"
ruby ${dirname}/dataqube-parser/src/main.rb $@ 
