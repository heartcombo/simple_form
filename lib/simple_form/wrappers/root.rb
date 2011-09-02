module SimpleForm
  module Wrappers
    class Root < Many
      def initialize(*args)
        super(:wrapper, *args)
      end

      def render(input)
        if components = input.options[:components]
          super(input, SimpleForm::Wrappers.wrap(components))
        else
          super
        end
      end

      private

      def html_classes(input, options)
        css = super
        css << @defaults[:error_class] || options[:wrapper_error_class] if input.has_errors?
        css << "disabled" if input.disabled?
        css        
      end
    end
  end
end