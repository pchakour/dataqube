require 'git'
require 'fileutils'
require 'bundler'
require 'colorize'

VERSION = File.read("VERSION")
root_folder = File.dirname(__FILE__)
src_folder = File.join root_folder, 'src'
fluentd_plugins_folder = File.join(src_folder, 'fluentd-plugins')
dataqube_plugin_folder = File.join fluentd_plugins_folder, 'fluent-plugin-dataqube'
dataqube_lib_folder = File.join src_folder, 'dataqube-ruby'
autoshutdown_plugin_folder = File.join fluentd_plugins_folder, 'fluent-plugin-autoshutdown'
dist_folder = File.join root_folder, 'dist'

task :build do
  puts 'Building gems'.green
  # Generate dataqube-ruby and autoshutdown
  puts 'Build fluent-plugin-autoshutdown gem'
  Dir.chdir(autoshutdown_plugin_folder) do
    `gem build fluent-plugin-autoshutdown.gemspec`
  end

  puts 'Build dataqube-ruby gem'
  Dir.chdir(dataqube_lib_folder) do
    `gem build dataqube-ruby.gemspec`
  end

  puts 'Build fluent-plugin-dataqube gem'
  Dir.chdir(dataqube_plugin_folder) do
    `gem build fluent-plugin-dataqube.gemspec`
  end
end

task :install => [:clean, :build] do
  puts 'Running installation'.green

  puts 'Installation of gem'.blue
  puts 'Installation of fluent-plugin-autoshutdown gem'
  Dir.chdir(root_folder) do
    `gem install src/fluentd-plugins/fluent-plugin-autoshutdown/fluent-plugin-autoshutdown-0.0.1.gem --install-dir vendor/bundle/ruby/3.1.0`
  end

  puts 'Installation of dataqube-ruby gem'
  Dir.chdir(root_folder) do
    `gem install src/dataqube-ruby/dataqube-ruby-0.0.1.gem  --install-dir vendor/bundle/ruby/3.1.0`
  end

  puts 'Installation of fluent-plugin-dataqube gem'
  Dir.chdir(root_folder) do
    `gem install src/fluentd-plugins/fluent-plugin-dataqube/fluent-plugin-dataqube-0.0.1.gem  --install-dir vendor/bundle/ruby/3.1.0`
  end
end

task :clean do
  puts 'Cleaning previous installation'.green
  FileUtils.rm_rf Dir.glob(File.join(dataqube_lib_folder, 'dataqube-ruby-*.gem'))
  FileUtils.rm_rf Dir.glob(File.join(dataqube_plugin_folder, 'fluent-plugin-dataqube-*.gem'))
  FileUtils.rm_rf Dir.glob(File.join(autoshutdown_plugin_folder, 'fluent-plugin-autoshutdown-*.gem'))
  FileUtils.rm_rf dist_folder
end

task :distribute => [:install] do
  puts 'Distributing application'.green
  Dir.mkdir dist_folder
  package_name = "dataqube-#{VERSION}"

  puts 'Building dataqube gem'.blue
  Dir.chdir(root_folder) do
    `gem build dataqube.gemspec -o #{dist_folder}/#{package_name}.gem`
  end

  puts 'Building tar.gz'.blue
  Dir.chdir(dist_folder) do
    `gem unpack #{package_name}.gem`
    `tar -czf #{package_name}.tar.gz #{package_name}`
    FileUtils.rm_rf package_name
  end

end