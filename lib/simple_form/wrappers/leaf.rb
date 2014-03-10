module SimpleForm
  module Wrappers
    class Leaf
      attr_reader :namespace, :options

      def initialize(namespace, options={})
        @namespace = namespace
        @options = options
      end

      def render(input)
        input.send(@namespace, self)
      end

      def find(name)
        return self if @namespace == name
      end
    end
  end
end
