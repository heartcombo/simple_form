module SimpleForm
  module Wrappers
    class Root < Many
      def initialize(*args)
        super(:wrapper, *args)
      end

      private

      def wrap(input, options, content)
        return content if options[:wrapper] == false
        super
      end

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