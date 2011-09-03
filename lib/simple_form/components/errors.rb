module SimpleForm
  module Components
    module Errors
      include SimpleForm::Helpers::HasErrors

      def error
        enabled_error
      end

      def error_tag
        options[:error_tag] || SimpleForm.error_tag
      end

      def error_text
        if options[:error_prefix]
          options[:error_prefix] + " " + errors.send(error_method)
        else
          errors.send(error_method)
        end
      end

      def error_method
        options[:error_method] || SimpleForm.error_method
      end

      def error_html_options
        html_options_for(:error, [SimpleForm.error_class])
      end

    protected

      def enabled_error
        template.content_tag(error_tag, error_text, error_html_options) if has_errors?
      end

      def disabled_error
        nil
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
