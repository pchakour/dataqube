require 'dry-schema'

module Dry
  module Schema
    module Macros
      class DSL < Core
        def description(text)
          type(schema_dsl.types[name].meta(description: text))
          self
        end
        def default(value)
          type(schema_dsl.types[name].meta(default: value))
          self
        end
        def isInterpreted
          type(schema_dsl.types[name].meta(interpreted: true))
          self
        end
      end
    end
  end
end

Dry::Schema.load_extensions(:json_schema)
Dry::Schema.load_extensions(:info)

module Dry
  module Schema
    module JSONSchema
      class SchemaCompiler
        def visit_key(node, opts = EMPTY_HASH)
          name, rest = node
          type = nil

          begin
            begin
              if opts[:types][name].meta
                type = opts[:types][name]
              end
            rescue
              type = opts[:types].find{ |type| type.name == name }
            end
          rescue
            type = opts[:types].type.member.keys.find{ |type| type.name == name }
          end

          description = type.meta[:description]
          default = type.meta[:default]
          interpreted = type.meta[:interpreted] ? true : false

          if opts.fetch(:required, :true)
            required << name.to_s
          else
            opts.delete(:required)
          end

          keys.update(name => {description: description, default: default, interpreted: interpreted})
          new_opts = opts.merge(key: name)
          new_opts[:types] = type
          visit(rest, new_opts)
        end

        def call(ast, types)
          visit(ast, { :types => types })
        end
      end
    end
  end
end

module Dry
  module Schema
    # JSONSchema extension
    #
    # @api public
    module JSONSchema
      module SchemaMethods
        # Convert the schema into a JSON schema hash
        #
        # @param [Symbol] loose Compile the schema in "loose" mode
        #
        # @return [Hash<Symbol=>Hash>]
        #
        # @api public
        def json_schema(loose: false)
          compiler = SchemaCompiler.new(root: true, loose: loose)
          compiler.call(to_ast, types)
          compiler.to_hash
        end
      end
    end
  end
end

def config_schema(&block)
  Dry::Schema.JSON(&block)
end

SYSTEM_SCHEMA = config_schema do
  optional(:autostop).filled(:hash).schema do
    optional(:enabled).filled(:bool).default(true)
    optional(:timeout).filled(:integer).default(20)
  end
end
