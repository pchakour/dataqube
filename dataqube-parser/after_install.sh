rm -rf ./fluentd/plugins/*
mkdir -p ./fluentd/plugins/dataqube
cp -rf fluent-plugin-dataqube/* ./fluentd/plugins/dataqube
cp -rf ../dataqube-ruby ./fluentd/plugins/dataqube/dataqube-ruby
cp -rf fluent-plugin-autoshutdown ./fluentd/plugins