require 'git'
require 'fileutils'
require 'bundler'
require 'colorize'

FLUENT_GIT_URL = 'https://github.com/fluent/fluentd.git'
current_folder = File.dirname(__FILE__)
dataqube_parser_folder = File.join(current_folder, 'dataqube-parser')
dataqube_ruby_folder = File.join(current_folder, 'dataqube-ruby')
fluentd_folder = File.join(dataqube_parser_folder, 'fluentd')
dataqube_plugin_folder = File.join dataqube_parser_folder, 'fluent-plugin-dataqube'
autoshutdown_plugin_folder = File.join dataqube_parser_folder, 'fluent-plugin-autoshutdown'

desc "Install all dependencies"
task :install,[:fluent_elasticsearch_plugin_version, :elasticsearch_version] => [:clean] do |t, args|
  puts 'Running installation'.green
  fluent_elasticsearch_plugin_version = args[:fluent_elasticsearch_plugin_version] || "5.3.0"
  elasticsearch_version = args[:elasticsearch_version] || "8.8.0"
  fluentd_src_folder = File.join(current_folder, 'fluentd-src')
  Dir.mkdir(fluentd_folder)
  puts 'Cloning fluentd parser'.blue
  Git.clone FLUENT_GIT_URL, fluentd_src_folder

  puts 'Running bundler'.blue
  Bundler.with_unbundled_env do
    Dir.chdir(fluentd_src_folder) do
      `bundle config set --local path #{fluentd_folder}`
      `bundle install`
      `bundle exec rake build`
      `gem install pkg/$(ls ./pkg) --install-dir #{fluentd_folder}`
    end
  end

  puts 'Installing fluentd plugins'

  Bundler.with_unbundled_env do
    Dir.chdir(fluentd_folder) do
      `GEM_PATH="#{fluentd_folder}" bin/fluent-gem install elasticsearch:#{elasticsearch_version} --install-dir #{fluentd_folder}`
      `GEM_PATH="#{fluentd_folder}" bin/fluent-gem install fluent-plugin-elasticsearch:#{fluent_elasticsearch_plugin_version} --install-dir #{fluentd_folder}`
    end
  end

  puts 'Removing temp files'.blue
  FileUtils.rm_rf(fluentd_src_folder)
  Rake::Task[:configure_fluentd].invoke
end

task :configure_fluentd do
  puts 'Configuring fluentd parser'.green
  fluentd_plugins_folder = File.join fluentd_folder, 'plugins'
  FileUtils.rm_rf Dir.glob(File.join(fluentd_plugins_folder, '*'))

  Bundler.with_unbundled_env do
    Dir.chdir(dataqube_ruby_folder) do
      `gem build dataqube-ruby.gemspec -o dataqube-ruby.gem`
      `gem install dataqube-ruby.gem --install-dir #{fluentd_folder}`
    end
  end

  Bundler.with_unbundled_env do
    Dir.chdir(dataqube_plugin_folder) do
      `bundle config set --local path #{fluentd_folder}`
      `bundle install`
    end
  end
  FileUtils.cp_r dataqube_plugin_folder, fluentd_plugins_folder
  FileUtils.cp_r autoshutdown_plugin_folder, fluentd_plugins_folder
end

task :clean do
  puts 'Cleaning previous installation'.green
  FileUtils.rm_rf fluentd_folder
  FileUtils.rm_rf Dir.glob(File.join(dataqube_plugin_folder, 'dataqube-ruby-*.gem'))
end