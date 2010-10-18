module SimpleForm
  module Components
    module Errors
      def error
        template.content_tag(error_tag, error_text, error_html_options) if has_errors?
      end

      def error_tag
        options[:error_tag] || SimpleForm.error_tag
      end

      def error_text
        add_field_name_to_error ? error_text_with_attribute_name : error_text_without_attribute_name
      end

      def error_method
        options[:error_method] || SimpleForm.error_method
      end

      def add_field_name_to_error
        options[:add_field_name_to_error] || SimpleForm.add_field_name_to_error
      end

      def error_html_options
        html_options_for(:error, [:error])
      end

    protected
      def error_text_with_attribute_name
        "#{attribute_name.to_s.humanize} #{error_text_without_attribute_name}" 
      end

      def error_text_without_attribute_name
        errors.send(error_method)
      end

      def has_errors?
        object && object.respond_to?(:errors) && errors.present?
      end

      def errors
        @errors ||= (errors_on_attribute + errors_on_association).compact
      end

      def errors_on_attribute
        object.errors[attribute_name]
      end

      def errors_on_association
        reflection ? object.errors[reflection.name] : []
      end
    end
  end
end
