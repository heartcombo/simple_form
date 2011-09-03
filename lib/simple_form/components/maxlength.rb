module SimpleForm
  module Components
    module Maxlength
      def maxlength
        # This components is disabled by default.
        nil
      end

      private

      def active_maxlength
        if SimpleForm.html5
          input_html_options[:maxlength] ||= maximum_length_from_validation || limit
        end
        nil
      end

      def maximum_length_from_validation
        return unless has_validators?

        length_validator = find_length_validator or return
        length_validator.options[:maximum]
      end

      def find_length_validator
        attribute_validators.find { |v| ActiveModel::Validations::LengthValidator === v }
      end
    end
  end
end
