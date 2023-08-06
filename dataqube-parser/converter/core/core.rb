require_relative './extractors_loader'
require_relative './assertions_loader'
require_relative './transformers_loader'
require_relative './inputs_loader'
require_relative './outputs_loader'
require_relative './config'
require_relative './fluentd_convertor'
require_relative './config_validator'
require 'logger'

class Core

  def initialize()
    @logger = Logger.new(STDOUT)
    @inputs_loader = InputsLoader.new(@logger)
    @outputs_loader = OutputsLoader.new(@logger)
    @transformers_loader = TransformersLoader.new(@logger)
    @extractors_loader = ExtractorsLoader.new(@logger)
    @assertions_loader = AssertionsLoader.new(@logger)
    @config = Config.new()
  end

  def start()
    @inputs_loader.start()
    @outputs_loader.start()
    @extractors_loader.start()
    @transformers_loader.start()
    @assertions_loader.start()
  end
  
  def convert(config_path, injection_id, rules)
    @config.start(config_path, injection_id, rules)
    config_validate_and_apply_defaults(@config)
    # convertor_engine = FluentdConvertor.new(
    #   @inputs_loader,
    #   @outputs_loader,
    #   @extractors_loader,
    #   @transformers_loader,
    #   @assertions_loader
    # )
    # conversion = convertor_engine.convert(@config)
    conversion = ""
    return conversion
  end
end