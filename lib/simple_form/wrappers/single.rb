module SimpleForm
  module Wrappers
    class Single < Many
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