module SimpleForm
  module Components
    module Errors
      def error
        template.content_tag(error_tag, error_text, error_html_options) if object && errors.present?
      end

      def error_tag
        options[:error_tag] || SimpleForm.error_tag
      end

      def error_text
        errors.to_sentence
      end

      def error_html_options
        html_options_for(:error, :error)
      end

    protected

      def errors
        @errors ||= (errors_on_attribute + errors_on_association).compact
      end

      def errors_on_attribute
        Array(object.errors[attribute_name])
      end

      def errors_on_association
        reflection ? Array(object.errors[reflection.name]) : []
      end
    end
  end
end