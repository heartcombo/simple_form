module SimpleForm
  module Wrappers
    class Single < Many
      def initialize(name, options={})
        super(name, [name], options)
      end

      def render(input)
        options = input.options
        if options[namespace] == false
          nil
        else
          content = input.send(namespace)
          wrap(input, options, content) if content
        end        
      end
    end
  end
end