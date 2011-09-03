module SimpleForm
  module Wrappers
    # `Root` is the root wrapper for all components. It is special cased to
    # always have a namespace and to add special html classes.
    class Root < Many
      def initialize(*args)
        super(:wrapper, *args)
      end

      private

      def html_classes(input, options)
        css = options[:wrapper_class] ? Array.wrap(options[:wrapper_class]) : @defaults[:class]
        css += input.input_html_classes
        css << (options[:wrapper_error_class] || @defaults[:error_class]) if input.has_errors?
        css << "disabled" if input.disabled?
        css        
      end
    end
  end
end