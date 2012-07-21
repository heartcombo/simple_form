module SimpleForm
  module Wrappers
    # `Root` is the root wrapper for all components. It is special cased to
    # always have a namespace and to add special html classes.
    class Root < Many
      attr_reader :options

      def initialize(*args)
        super(:wrapper, *args)
        @options = @defaults.except(:tag, :class, :error_class, :hint_class)
      end

      def render(input)
        input.options.reverse_merge!(@options)
        super
      end

      # Provide a fallback if name cannot be found.
      def find(name)
        super || SimpleForm::Wrappers::Many.new(name, [name])
      end

      private

      def html_classes(input, options)
        css = options[:wrapper_class] ? Array.wrap(options[:wrapper_class]) : @defaults[:class]
        css += SimpleForm.additional_classes_for(:wrapper) { input.additional_classes }
        css << (options[:wrapper_error_class] || @defaults[:error_class]) if input.has_errors?
        css << (options[:wrapper_hint_class] || @defaults[:hint_class]) if input.has_hint?
        css.compact
      end
    end
  end
end
