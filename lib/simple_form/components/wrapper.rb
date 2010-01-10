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

      def wrapper_html_options
        html_options_for(:wrapper, input_type, required_class)
      end
    end
  end
end