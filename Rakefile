require 'git'
require 'fileutils'
require 'bundler'
require 'colorize'

RUBY_SHIP_GIT_URL = 'https://github.com/stephan-nordnes-eriksen/ruby_ship.git'
RUBY_TAR = 'https://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.4.tar.gz'
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

task :install => [:build] do
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

task :distribute => [:clean, :build] do
  puts 'Distributing application'.green
  puts 'Building portable ruby'.blue
  FileUtils.rm_rf dist_folder if File.directory?(dist_folder)
  ruby_ship_folder = File.join dist_folder, 'tmp'

  puts 'Cloning ruby_ship'
  Git.clone RUBY_SHIP_GIT_URL, ruby_ship_folder

  Dir.chdir(ruby_ship_folder) do
    puts "Getting ruby from #{RUBY_TAR}"
    `wget -q #{RUBY_TAR}`
    FileUtils.rm_rf File.join ruby_ship_folder, 'bin'
  end

  puts "Compiling portable ruby with ruby_ship"
  pid = Process.spawn("yes | ./tools/ruby_ship_build.sh #{File.basename RUBY_TAR}", chdir: ruby_ship_folder)
  Process.wait pid

  puts 'Distributing dataqube'.blue
  puts "Copying ruby binaries"
  FileUtils.cp_r(File.join(ruby_ship_folder, 'bin'), File.join(dist_folder, 'bin'))

  puts "Copying Gemfile and .bundle directory"
  FileUtils.cp_r(File.join(root_folder, 'Gemfile'), File.join(dist_folder))
  FileUtils.cp_r(File.join(root_folder, 'Gemfile.lock'), File.join(dist_folder))
  FileUtils.cp_r(File.join(root_folder, '.bundle'), File.join(dist_folder))
  bundle_config_path = File.join(dist_folder, '.bundle', 'config')
  File.write(bundle_config_path, 'BUNDLE_WITHOUT: "development"', mode: 'a+')

  puts "Copying dataqube files"
  FileUtils.cp_r(File.join(root_folder, 'bin', '.'), File.join(dist_folder, 'bin'))
  FileUtils.cp_r(File.join(root_folder, 'src'), File.join(dist_folder))
  FileUtils.cp_r(File.join(root_folder, 'vendor'), File.join(dist_folder))
  FileUtils.cp_r(File.join(root_folder, 'examples'), File.join(dist_folder))

  # Patching dataque bin
  dataqube_path = File.join(dist_folder, 'bin', 'dataqube')
  dataqube_content = File.read(dataqube_path)

  # Perform the text replacement
  new_dataqube_content = dataqube_content.gsub('RUBY_BIN="ruby"', 'RUBY_BIN="${dirname}/ruby_ship.sh"')

  # Write the updated content back to the file
  File.open(dataqube_path, 'w') { |file| file.write(new_dataqube_content) }

  # Patching linux ruby launcher
  ruby_path = File.join(dist_folder, 'bin', 'shipyard', 'linux_ruby.sh')
  ruby_content = File.read(ruby_path)

  # Perform the text replacement
  new_ruby_content = ruby_content.gsub('GEM_PATH="', 'GEM_PATH="${GEM_PATH}:')

  # Write the updated content back to the file
  File.open(ruby_path, 'w') { |file| file.write(new_ruby_content) }

  puts "Cleaning temp files"
  FileUtils.rm_rf ruby_ship_folder

  puts "Install dependencies"
  bundler_bin = File.join('bin', 'ruby_ship_bundle.sh')
  pid = Process.spawn("#{bundler_bin} install", chdir: dist_folder)
  Process.wait pid

end