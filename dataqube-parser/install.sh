mkdir fluentd
git clone https://github.com/fluent/fluentd.git fluentd-src
cd fluentd-src
bundle install --path $(pwd)/../fluentd
bundle exec rake build
gem install pkg/$(ls ./pkg) --install-dir $(pwd)/../fluentd
cd ..
rm -rf fluentd-src
sh after_install.sh