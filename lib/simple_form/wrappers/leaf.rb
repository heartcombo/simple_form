module SimpleForm
  module Wrappers
    class Leaf
      DEPRECATION_WARN = <<-WARN
%{name} method now accepts a `context` argument. The method definition without the argument is deprecated and will be removed in the next Simple Form version. Change your code from:

    def %{name}

to

    def %{name}(context)
      WARN

      attr_reader :namespace, :options

      def initialize(namespace, options={})
        @namespace = namespace
        @options = options
      end

      def render(input)
        method = input.method(@namespace)

        if method.arity == 0
          ActiveSupport::Deprecation.warn(DEPRECATION_WARN % { name: @namespace })

          method.call
        else
          method.call(self)
        end
      end

      def find(name)
        return self if @namespace == name
      end
    end
  end
end
