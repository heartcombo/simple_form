module SimpleForm
  module Components
    module Errors
      include SimpleForm::Helpers::HasErrors

      def error
        enabled_error
      end

    protected

      def enabled_error
        error_text if has_errors?
      end

      def disabled_error
        nil
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
