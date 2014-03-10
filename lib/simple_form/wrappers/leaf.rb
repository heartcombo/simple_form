module SimpleForm
  module Wrappers
    class Leaf
      attr_reader :namespace

      def initialize(namespace)
        @namespace = namespace
      end

      def render(input)
        input.send(@namespace)
      end

      def find(name)
        return self if @namespace == name
      end
    end
  end
end
