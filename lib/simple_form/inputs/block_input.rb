module SimpleForm
  module Inputs
    class BlockInput < Base
      def initialize(*args, &block)
        super
        @block = block
      end

      def input(context = nil)
        template.capture(&@block)
      end
    end
  end
end
