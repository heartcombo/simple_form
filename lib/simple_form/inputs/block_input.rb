module SimpleForm
  module Inputs
    class BlockInput < Base
      def initialize(builder, block)
        @builder, @block = builder, block
      end

      def input
        template.capture(&@block)
      end
    end
  end
end