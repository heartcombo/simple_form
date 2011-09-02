module SimpleForm
  module Wrappers
    class Anonym < Many
      def initialize(*args)
        super(nil, *args)
      end

      def wrap(input, options, content)
        content
      end
    end
  end
end