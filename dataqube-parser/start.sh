# curl -XDELETE -k https://admin:admin@localhost:9200/fluentd-*
curl -XDELETE http://localhost:9200/fluentd-*
ruby src/main.rb
cd ..

cat inputs.conf > ./test_fluentd.conf
cat converter/conversion.conf >> ./test_fluentd.conf
cat outputs.conf >> ./test_fluentd.conf
./fluentd/bin/fluentd -c ./test_fluentd.conf