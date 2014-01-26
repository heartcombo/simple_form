module SimpleForm
  module Components
    module Errors
      def error
        error_text if has_errors?
      end

      def has_error_in_options?
        options[:error] && !options[:error].nil?
      end

      def has_errors?
        (object && object.respond_to?(:errors) && errors.present?) || has_error_in_options?
      end

      protected

      def error_text
        "#{html_escape(options[:error_prefix])} #{errors.send(error_method)}".lstrip.html_safe
      end

      def error_method
        options[:error_method] || SimpleForm.error_method
      end

      def errors
        @errors ||= (errors_on_attribute + errors_on_association).compact
      end

      def errors_on_attribute
        has_error_in_options? ? [options[:error]] : object.errors[attribute_name]
      end

      def errors_on_association
        reflection ? object.errors[reflection.name] : []
      end
    end
  end
end
