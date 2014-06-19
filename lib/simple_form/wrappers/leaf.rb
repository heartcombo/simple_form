module SimpleForm
  module Wrappers
    class Leaf
      attr_reader :namespace

      def initialize(namespace, options = {})
        @namespace = namespace
        @options = options
      end

      def render(input)
        method = input.method(@namespace)

        if method.arity == 0
          if method.name !~ /_text$/
            ActiveSupport::Deprecation.warn(SimpleForm::CUSTOM_INPUT_DEPRECATION_WARN % { name: @namespace })
          end

          method.call
        else
          method.call(@options)
        end
      end

      def find(name)
        self if @namespace == name
      end
    end
  end
end
