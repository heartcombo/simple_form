module SimpleForm
  module Inputs
    class BlockInput < Base
      def initialize(*args, &block)
        super
        @block = block
      end

      def input
        template.capture(&@block)
      end

      def has_placeholder?
        false
      end
    end
  end
end