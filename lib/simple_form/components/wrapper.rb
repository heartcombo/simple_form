module SimpleForm
  module Components
    module Wrapper
      def wrap(content)
        if wrapper_tag && options[:wrapper] != false
          template.content_tag(wrapper_tag, content, wrapper_html_options)
        else
          content
        end
      end

      def wrapper_tag
        options[:wrapper_tag] || SimpleForm.wrapper_tag
      end

      def wrapper_class
        options[:wrapper_class] || SimpleForm.wrapper_class
      end

      def errors_class
        options[:wrapper_error_class] || SimpleForm.wrapper_error_class
      end

      def wrapper_html_options
        css_classes = [wrapper_class, input_type, required_class]
        css_classes << errors_class if object && errors.present?
        html_options_for(:wrapper, css_classes)
      end
    end
  end
end
