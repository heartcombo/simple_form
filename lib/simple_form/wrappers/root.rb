module SimpleForm
  module Wrappers
    # `Root` is the root wrapper for all components. It is special cased to
    # always have a namespace and to add special html classes.
    class Root < Many
      attr_reader :options

      def initialize(*args)
        super(:wrapper, *args)
        @options = @defaults.except(:tag, :class, :error_class)
      end

      def render(input)
        input.options.reverse_merge!(@options)
        super
      end

      # Provide a fallback if name cannot be found.
      def find(name)
        super || SingleForm::Wrappers::Many.new(name, [name])
      end

      private

      def html_classes(input, options)
        css = options[:wrapper_class] ? Array.wrap(options[:wrapper_class]) : @defaults[:class]
        css += input.html_classes
        css << (options[:wrapper_error_class] || @defaults[:error_class]) if input.has_errors?
        css
      end
    end
  end
end
