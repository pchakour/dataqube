require 'timeout'
require 'fluent/plugin/output'

module Fluent::Plugin
  class Autoshutdown < Output
    # First, register the plugin. 'NAME' is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_output('autoshutdown', self)

    # Define parameters for your plugin.
    config_param :timeout, :integer, default: 10 # 10 seconds
    @thread = nil

    def prefer_buffered_processing
      false
    end

    def multi_workers_ready?
      true
    end

    def configure(conf)
      super
    end

    def process(tag, es)
      if @thread != nil
        @thread.kill
        @thread = nil
      end

      @thread = Thread.new do
        sleep @timeout
        @thread = nil
        $log.write("Shutdown fluent after timeout #{@timeout}s\n")
        Fluent::Engine.stop
      end
    end
  end
end