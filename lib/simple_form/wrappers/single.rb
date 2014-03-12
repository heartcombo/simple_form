module SimpleForm
  module Wrappers
    # `Single` is an optimization for a wrapper that has only one component.
    class Single < Many
      def initialize(name, wrapper_options = {}, options = {})
        super(name, [Leaf.new(name, options)], wrapper_options)
      end

      def render(input)
        options = input.options
        if options[namespace] != false
          content = component.render(input)
          wrap(input, options, content) if content
        end
      end

      private

      def component
        components.first
      end

      def html_options(options)
        [:label, :input].include?(namespace) ? {} : super
      end
    end
  end
end
