# !/bin/sh

dirname="$(dirname "$0")"
directory_path=${dirname}/.gems/ruby
ruby_version=$(find "$directory_path" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
gem_repository=${directory_path}/${ruby_version}
echo $gem_repository

GEM_PATH=${gem_repository} ruby ${dirname}/dataqube-parser/src/main.rb $@ &
PID=$!

handle_sigterm() {
   echo "SIGTERM received, exiting now"
   kill -15 $PID
   exit 143
}

handle_sigint() {
   echo "SIGINT received, exiting now"
   kill -15 $PID
   exit 130
}

handle_sigkill() {
   echo "SIGKILL received, exiting now"
   kill -15 $PID
   exit 137
}

trap handle_sigterm TERM
trap handle_sigint INT
trap handle_sigkill KILL

wait $PID
