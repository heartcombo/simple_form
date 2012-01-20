module SimpleForm
  module Wrappers
    # `Single` is an optimization for a wrapper that has only one component.
    class Single < Many
      def initialize(name, options={})
        super(name, [name], options)
      end

      def render(input)
        options = input.options
        if options[namespace] != false
          content = input.send(namespace)
          wrap(input, options, content) if content
        end
      end
    end
  end
end
